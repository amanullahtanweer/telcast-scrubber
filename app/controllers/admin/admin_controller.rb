class Admin::AdminController < ApplicationController
	before_action :authenticate_admin!

	def reports 
	end


	private

	def authenticate_admin!
    redirect_to root_path unless current_user.is_admin? || current_user.is_reseller?
  end
  
end