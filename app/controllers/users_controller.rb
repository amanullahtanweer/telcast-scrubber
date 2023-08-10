class UsersController < ApplicationController
  respond_to :html, :json

  before_action :require_admin!, except: [:stop_impersonating]


  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to admin_users_path
  end

  
  def stop_impersonating
    stop_impersonating_user
    redirect_to admin_users_path
  end

  private

  def require_admin!
    redirect_to root_path unless current_user.is_admin? || current_user.is_reseller?
  end


end