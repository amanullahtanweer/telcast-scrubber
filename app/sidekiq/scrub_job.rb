class ScrubJob
  require 'csv'
  include Sidekiq::Job
  sidekiq_options retry: 0


  def perform(result_id)
    begin
      @result = Result.find(result_id)
      csv_column = @result.csv_column || 0
      file_name = @result.name.split(".csv")[0]
      good_count = 0
      bad_count = 0
      invalid_count = 0
      good_rows = []
      bad_rows  = []
      mapped_rows = []

      rows = CSV.parse(@result.file.download, headers: false)
      headers = CSV.generate_line(rows[0])

      # More than 1 than column
      if rows[0].length > 1
        good_rows << headers
        bad_rows << headers
        rows.pop
      end

      # Remove any invalid number
      rows.each do |row|
        phone = row[csv_column].delete_prefix("1")
        if phone.length == 10
          mapped_rows << row
        else
          invalid_count += 1
        end
      end
      puts mapped_rows
      puts mapped_rows.count
      start_time = DateTime.now
      master = $redis.SMEMBERS 'master'
      found  = $redis.SMISMEMBER 'master', mapped_rows.map{|row| row[csv_column]}

      mapped_rows.each_with_index do |row, index|
        if found[index] == 1
          bad_count += 1
          bad_rows << CSV.generate_line(row)
        else
          good_count += 1
          good_rows << CSV.generate_line(row)
        end
      end
      puts bad_rows.join("\n")

      @result.rows = rows.count
      @result.good_rows = good_count
      @result.bad_rows = bad_count
      @result.finished_at = start_time
      @result.job_status  = 'finished'

      @result.good_file.attach(io: StringIO.new(good_rows.join("")),
                              filename: "#{file_name}-GOOD.csv",
                              content_type: 'text/csv')
      @result.bad_file.attach(io: StringIO.new(bad_rows.join("")),
                              filename: "#{file_name}-BAD.csv",
                              content_type: 'text/csv')                        
      @result.save
    
    rescue => error
      @result.job_status = 'failed'
      @result.finished_at = DateTime.now
      @result.save
      raise error
    end
  end
end
