class SessionsController < Devise::SessionsController
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ErrorSerializer

  authorize_resource :class => false
  
  #skip_before_action :verify_authenticity_token

  def create
    
    @user = User.find_by_email(params[:user][:email])
    if @user
      if @user.valid_password?(params[:user][:password])
        new_auth_header = @user.create_new_auth_token
        response.headers.merge!(new_auth_header)
        sign_in @user
    	success @user
      else
        @user.errors.add(:incorrect_login, "El correo electrónico o la contraseña son incorrectos.")
        error @user
      end
    else
      @user = User.new
      @user.errors.add(:incorrect_login, "El correo electrónico o la contraseña son incorrectos.")
      error @user
    end
  end

  def get
    if current_user
      @user = current_user
      success @user
    else
      @user = User.new
      @user.errors.add(:no_session, "No se ha iniciado sesión.")
      error @user
    end
  end

  def success user
    render json: user
  end

  def error user
    render json: ErrorSerializer.serialize(user.errors), status: 500
  end

end
