class Api::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :download]
  def create
    user = User.find_by(api_key: params[:api_key])

    if user
      sign_in user
      redirect_to root_url
    else
      render json: { message: 'Invalid API Key' }, status: :unauthorized
    end
  end

  def download
    
  end
end