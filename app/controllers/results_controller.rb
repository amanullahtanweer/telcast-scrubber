class ResultsController < ApplicationController

  def index
    if current_user.is_admin?
      @q = Result.includes(:user).ransack(params[:q])
      @pagy, @results = pagy(@q.result)
      

    else
      @q = current_user.results.includes(:user).ransack(params[:q])
      @pagy, @results = pagy(@q.result)
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
