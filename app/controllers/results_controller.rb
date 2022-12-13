class ResultsController < ApplicationController

  def index
    @results = current_user.results
  end

  def create
    @result = Result.new
    @result.user = current_user
    @result.csv_column = params['csv_column'].to_i
    @result.file = params['result']['file']
    @result.name = params['result']['file'].original_filename
    @result.rows = 0
    @result.job_status = 'processing'
    @result.save
    redirect_to results_url
  end

 
end
