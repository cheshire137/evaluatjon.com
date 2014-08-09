class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender

  protected

  def authenticate_user_from_token!
    email = params[:email].presence
    user = email && User.find_by_email(email)
    if user && Devise.secure_compare(user.auth_token, params[:token])
      sign_in user, store: false
    end
  end
end
