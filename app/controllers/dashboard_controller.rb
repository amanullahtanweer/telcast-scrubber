class DashboardController < ApplicationController

  def index
    @result = Result.new
  end
  
  def manual
  end

  def manual_result
    @result = ""
    render 'download'
  end

end
