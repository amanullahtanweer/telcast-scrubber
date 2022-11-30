class ScrubJob
  require 'csv'
  include Sidekiq::Job

  def perform(result_id)

    @result = Result.find(result_id)
    csv_column = @result.csv_column || 0
    file_name = @result.name.split(".csv")[0]
    rows_count = 0
    good_count = 0
    bad_count = 0
    invalid_count = 0

    good_rows = []
    bad_rows  = []

    
    mapped_rows = []

    rows = CSV.parse(@result.file.download, headers: false)
    rows.each do |row|
      rows_count += 1
      phone = row[csv_column].delete_prefix("1")
      if phone.length == 10
        mapped_rows << row
      else
        invalid_count += 1
      end
      
    end
    start_time = DateTime.now
    master = $redis.SMEMBERS 'master'
    found  = $redis.SMISMEMBER 'master', mapped_rows.map{|row| row[csv_column]}

    mapped_rows.each_with_index do |row, index|
      if found[index] == 1
        bad_count += 1
        bad_rows << row
      else
        good_count += 1
        good_rows << row
      end
    end

    @result.rows = rows_count
    @result.good_rows = good_count
    @result.bad_rows = bad_count
    @result.finished_at = start_time
    @result.job_status  = 'finished'

    @result.good_file.attach(io: StringIO.new(good_rows.join("\n")),
                            filename: "#{file_name}-GOOD.csv",
                            content_type: 'text/csv')
    @result.bad_file.attach(io: StringIO.new(bad_rows.join("\n")),
                            filename: "#{file_name}-BAD.csv",
                            content_type: 'text/csv')                        
    @result.save
    


  end
end
