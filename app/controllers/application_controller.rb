class ApplicationController < ActionController::Base
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
end
