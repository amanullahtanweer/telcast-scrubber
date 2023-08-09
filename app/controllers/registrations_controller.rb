class RegistrationsController < Devise::RegistrationsController
  before_action :set_ref_from_query_param, only: [:new]

  private

  def set_ref_from_query_param
    ref_param = params[:ref]
    session[:ref] = ref_param.to_i if ref_param.present?
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :parent_user_id, :company, :name, :datasets)
  end
end