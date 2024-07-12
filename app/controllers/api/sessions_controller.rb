class Api::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :download, :list]
  def create
    user = User.find_by(api_key: params[:api_key])

    if user
      sign_in user
      redirect_to root_url
    else
      render json: { message: 'Invalid API Key' }, status: :unauthorized
    end
  end

  def list
    user = User.find_by(api_key: params[:api_key])
    if user
      @results = Result.where(user_id: user.id, job_status: "finished").limit(20).map do |result|
        result.as_json.merge(good_file_url: url_for(result.good_file))
      end
      render json: @results, status: :ok
    else
      render json: { message: 'Invalid API Key' }, status: :unauthorized
    end
  end

  def download

  end


  private
end
