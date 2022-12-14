class DashboardController < ApplicationController
  before_action :check_user

  def index
    @result = Result.new
  end
  
  def manual
  end

  def manual_result
    numbers = params['numbers'] || []
		numbers = numbers.split("\r\n")
    numbers = numbers.map {|x| x.delete_prefix('1')}
    numbers = numbers.reject {|x| x.length != 10}
    @good_numbers = []
    @bad_numbers  = []
    if numbers.count > 0
      master = $redis.SMEMBERS 'master'
      found  = $redis.SMISMEMBER 'master', numbers
    end

    numbers.each_with_index do |row, index|
      if found[index] == 1
        @bad_numbers << row
      else
        @good_numbers << row
      end
    end

    render 'download'
  end

  private

  def check_user
    if !current_user.is_active
      redirect_to results_path, alert: "Inactive Account - Please contact support"
    end
  end

end
