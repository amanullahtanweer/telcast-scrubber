class Result < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  has_one_attached :good_file
  has_one_attached :bad_file

  after_create_commit :start_scrubbing


  def start_scrubbing
    ScrubJob.perform_async(self.id)
  end
end
