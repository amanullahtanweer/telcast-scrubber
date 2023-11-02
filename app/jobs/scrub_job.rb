class ScrubJob < ApplicationJob
  require 'csv'
  sidekiq_options retry: 1


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
      mapped_lrn_rows = []

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
        if row[csv_column]
          phone = row[csv_column].strip.delete_prefix("1") rescue nil
          if phone.length == 10
            row[csv_column] = phone
            mapped_rows << row
          else
            invalid_count += 1
          end
        end
      end
      start_time = DateTime.now

      lrn_numbers = $redis_lrn.HMGET 'lerg', mapped_rows.map{|row| row[csv_column]}
      mapped_rows.each_with_index do |row, index|
        if lrn_numbers[index].nil?
          mapped_lrn_rows[index] = row[csv_column]
        else
          mapped_lrn_rows[index] = lrn_numbers[index]
        end
      end


      if mapped_rows.count > 0
        master = $redis.SMEMBERS @result.dataset
        if @result.dataset == 'verizon'
          found  = $redis.SMISMEMBER @result.dataset, mapped_lrn_rows.map{|row| row[0, 6] }
        end

        if @result.dataset == 'ipes'
          found  = $redis.SMISMEMBER @result.dataset, mapped_lrn_rows.map{|row| row[0, 6] }
        end

        if @result.dataset == 'master'
          found  = $redis.SMISMEMBER @result.dataset, mapped_rows.map{|row| row[csv_column]}
        end

        if @result.dataset == 'dnc'
          found  = $redis_lrn.SMISMEMBER 'dnc', mapped_rows.map{|row| row[csv_column]}
        end

        if @result.dataset == 'masteripes'
          found  = $redis.SMISMEMBER @result.dataset, mapped_rows.map{|row| row[csv_column]}
          masteripes  = $redis.SMISMEMBER @result.dataset, mapped_lrn_rows.map{|row| row[0, 6] }
          mapped_rows.each_with_index do |row, index|
            if masteripes[index] == 1
              found[index] = 1
            end
          end
        end

        if @result.dataset == 'masterverizon'
          found  = $redis.SMISMEMBER @result.dataset, mapped_rows.map{|row| row[csv_column]}
          verizon  = $redis.SMISMEMBER @result.dataset, mapped_lrn_rows.map{|row| row[0, 6] }
          mapped_rows.each_with_index do |row, index|
            if verizon[index] == 1
              found[index] = 1
            end
          end
        end

      end

      mapped_rows.each_with_index do |row, index|
        if found[index] == 1
          bad_count += 1
          bad_rows << CSV.generate_line(row)
        else
          good_count += 1
          good_rows << CSV.generate_line(row)
        end
      end

      @result.rows = rows.count
      @result.good_rows = good_count
      @result.bad_rows = bad_count
      @result.finished_at = start_time
      @result.job_status  = 'finished'
      @result.invalid_rows = invalid_count

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
      @result.error_text = error.to_s
      @result.save
      raise error
    end
  end
end
