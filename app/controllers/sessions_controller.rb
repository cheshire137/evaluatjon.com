class SessionsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [:create]
  before_filter :ensure_params_exist
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    build_resource
    resource = User.find_for_database_authentication(
      email: params[:user][:email]
    )
    resource.reset_auth_token
    return invalid_login_attempt unless resource
    if resource.valid_password?(params[:user][:password])
      sign_in 'user', resource
      render json: {email: resource.email, auth_token: resource.auth_token}
    else
      invalid_login_attempt
    end
  end

  def destroy
    resource.reset_auth_token
    sign_out resource_name
  end

  protected

  def ensure_params_exist
    return unless params[:user].blank?
    render json: {error: 'Missing user parameter'}, status: 422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: {error: 'Invalid email address or password'}, status: 401
  end
end
