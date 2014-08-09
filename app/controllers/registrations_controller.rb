class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  skip_before_filter :verify_authenticity_token

  def create
    render json: {error: 'You are not Jon.'}, status: :forbidden
  end

  def update
    render json: {error: 'No updating allowed.'}, status: :forbidden
  end
end
