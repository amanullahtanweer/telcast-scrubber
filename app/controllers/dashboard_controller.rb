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
    dataset = params['dataset']
    if numbers.count > 0
      if dataset == 'verizon'
          found  = $redis.SMISMEMBER dataset, numbers.map{|row| row[0, 6] }
        end

        if dataset == 'ipes'
          found  = $redis.SMISMEMBER dataset, numbers.map{|row| row[0, 6] }
        end
        if dataset == 'master' 
          found  = $redis.SMISMEMBER dataset, numbers.map{|row| row}
        end

        if dataset == 'masteripes' 
          found  = $redis.SMISMEMBER dataset, numbers.map{|row| row}
          masteripes  = $redis.SMISMEMBER dataset, numbers.map{|row| row[0, 6] }
          numbers.each_with_index do |row, index|
            if masteripes[index] == 1
              found[index] = 1
            end
          end
        end

        if dataset == 'masterverizon' 
          found  = $redis.SMISMEMBER dataset, numbers.map{|row| row}
          verizon  = $redis.SMISMEMBER dataset, numbers.map{|row| row[0, 6] }
          numbers.each_with_index do |row, index|
            if verizon[index] == 1
              found[index] = 1
            end
          end
        end
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
