class DatasetsController < ApplicationController


  def index
    
  end

  def modify 
  end

  def modify_dataset
    numbers = params['numbers'] || []
		numbers = numbers.split("\r\n")
    numbers = numbers.map {|x| x.delete_prefix('1')}
    numbers = numbers.reject {|x| x.length != 10}
    
    if numbers.count > 0
      if params['modify_action'] == "add"
        $redis.sadd 'master', numbers
      else
        $redis.srem 'master', numbers
      end
    end
    flash[:notice] = "#{numbers.length} numbers reflected to master dataset"

    redirect_to datasets_url
  end

  
end
