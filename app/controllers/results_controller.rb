class ResultsController < ApplicationController

  def index
    session[:per_page] = params[:per_page] if params[:per_page]
    @per_page = session[:per_page]
    if current_user.is_admin?
      @users = User.all
      @q = Result.includes(:user).ransack(params[:q])
      @pagy, @results = pagy(@q.result, items: session[:per_page] || "10")
    elsif current_user.is_reseller?
      @users = current_user.sub_users
      @q = Result.includes(:user).where(user_id: current_user.sub_users.ids.push(current_user.id)).ransack(params[:q])
      @pagy, @results = pagy(@q.result, items: session[:per_page] || "10")
    else
      @q = current_user.results.includes(:user).ransack(params[:q])
      @pagy, @results = pagy(@q.result, items: session[:per_page] || "10")
    end
  end

  def create
    @result = Result.new
    @result.user = current_user
    @result.csv_column = params['result']['csv_column'].to_i
    @result.file = params['result']['file']
    @result.name = params['result']['file'].original_filename
    @result.dataset = params['result']['dataset']
    @result.rows = 0
    @result.job_status = 'processing'
    @result.save
    redirect_to results_url
  end

 
end
