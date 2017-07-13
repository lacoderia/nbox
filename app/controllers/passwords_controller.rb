class PasswordsController < Devise::PasswordsController
  include ErrorSerializer

  authorize_resource :class => false
  
  #skip_before_action :verify_authenticity_token, :only => [:create, :update]

  def create
    self.resource = User.find_by_email(resource_params['email'])

    if self.resource
    
      yield resource if block_given?

      token = resource.send_reset_password_instructions

      if successfully_sent?(resource)
        success resource, token
      else
        resource.errors.add(:reset_email_not_sent, "No se pudo enviar el password reset para el usuario.")
        error resource
      end

    else
      resource = User.new
      resource.errors.add(:no_user_found, "No se encontró usuario con ese email.")
      error resource
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      success resource
    else
      error resource
    end
  end
   
  def success user, token = nil
    if token
      render json: {user: user, token: token}
    else
      render json: user
    end
  end

  def error user
    render json: ErrorSerializer.serialize(user.errors), status: 500
  end

end
