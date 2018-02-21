class UsersController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!
  
  before_action :set_user, only: [:update, :send_coupon_by_email]

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      if user_params[:password]
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        sign_in(@user)

        if @user.linked
         
          # remote update password
          @user.remote_login_and_set_headers
          remote_valid_update = User.remote_update_account(@user.email, user_params[:password], @user.headers)
          #local update password
          valid_update = @user.update_account(@user.email, user_params[:password])
          if not (valid_update and remote_valid_update.code == "200")
            raise 'La actualización de contraseña no pudo realizarse. Favor de ponerse en contacto con el administrador.' 
          else
            @user.set_headers(Connection.get_headers remote_valid_update)
          end

        end
        
      end
      render json: @user
    else
      render json: ErrorSerializer.serialize(@user.errors)
    end
  end

  def send_coupon_by_email
    begin
      coupon = @user.send_coupon_by_email params[:email]
      render json: CouponSerializer.serialize(coupon) 
    rescue Exception => e
      errors = {:error_sending_coupon => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  # Bidirectional connection between N-bici and N-box servers
  
  # CALLED FROM THE FRONT END

  # @email remote system username
  # @password remote system password
  def remote_authenticate 
    begin
      response = User.remote_authenticate params[:email], params[:password] 
      if response.code == "200" 
        
        remote_user_linked = JSON.parse(response.body)["user"]["linked"]
        if remote_user_linked
          raise 'La cuenta de N-bici ya ha sido sincronizada anteriormente'
        end
        
        current_user.set_headers(Connection.get_headers response)
        render json: current_user, status: :ok
      else
        raise 'El correo electrónico o la contraseña son incorrectos.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  # @email definitive username for both systems
  # @password definitive password for both systems
  def synchronize_accounts
    begin
      remote_valid_email = User.remote_validate_email(params[:email], current_user.headers)
      valid_email = current_user.validate_email(params[:email])
      
      if valid_email and remote_valid_email.code == "200"

        # synchronize user, password
        @user = current_user
        remote_valid_update = User.remote_update_account(params[:email], params[:password], current_user.headers)
        valid_update = current_user.update_account(params[:email], params[:password]) 
 
        if valid_update and remote_valid_update.code == "200"
          bypass_sign_in(@user)
          @user.set_headers(Connection.get_headers remote_valid_update)
          render json: @user, status: :ok
        else
          raise 'La sincronización de usuario y contraseña no pudo realizarse. Favor de ponerse en contacto con el administrador.' 
        end

      else
        raise 'El correo seleccionado tiene a un usuario que no está vinculado a esta cuenta. Favor de ponerse en contacto con el administrador.'
      end

    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  # CALLED FROM SYSTEM TO SYSTEM 

  # @email
  def validate_email
    begin
      valid_email = current_user.validate_email params[:email]
      if valid_email 
        render json: current_user, status: :ok
      else
        raise 'El correo seleccionado tiene a un usuario que no está vinculado a esta cuenta. Favor de ponerse en contacto con el administrador.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end
  
  def remote_login
    begin
      response = current_user.remote_login 
      if response.code == "200"
        current_user.set_headers(Connection.get_headers response)
        render json: current_user, status: :ok
      else
        raise 'Autenticación incorrecta.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  def update_account
    begin
      @user = current_user
      valid_update = current_user.update_account params[:email], params[:password]

      if valid_update
        bypass_sign_in(@user)      
        render json: @user, status: :ok
      else
        raise 'Error actualizando la cuenta.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  # N-box unique methods

  def send_classes_left
    begin
      valid_migration = current_user.update_attribute("linked", true)
      render json: current_user, status: :ok
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end

  def migrate_accounts
    begin
      # send classes_left 
      response = User.remote_send_classes_left(current_user.classes_left, current_user.expiration_date, current_user.headers)
      if response.code == "200"

        valid_migration = current_user.update_attribute("linked", true)
         
        if valid_migration
          render json: current_user, status: :ok
        else
          # should not happen
          # local rollback
          current_user.update_attribute("linked", false)
          raise 'Error migrando las clases disponibles hacia N-bici. Favor de ponerse en contacto con el administrador.'
        end        
      else
        raise 'Error enviando clases disponibles desde N-box. Favor de ponerse en contacto con el administrador.'
      end
    rescue Exception => e
      errors = {:error_authenticating => [e.message]}
      render json: ErrorSerializer.serialize(errors), status: 500
    end
  end
   
  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :classes_left, :last_class_purchased, :picture, :uid, :active, :password, :password_confirmation)
    end
end
