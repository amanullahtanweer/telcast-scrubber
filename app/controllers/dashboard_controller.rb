class DashboardController < ApplicationController

  def index
    @result = Result.new
  end
end
