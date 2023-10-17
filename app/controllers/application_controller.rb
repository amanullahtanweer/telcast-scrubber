class ApplicationController < ActionController::Base
  skip_forgery_protection
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pagy::Backend
  impersonates :user


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[company name datasets parent_user_id])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[company name datasets parent_user_id])
  end

  def skip_forgery_protection(options = {})
    skip_before_action :verify_authenticity_token
  end
end
