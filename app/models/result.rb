class Result < ApplicationRecord
  belongs_to :user
  has_one_attached :file, :dependent => :destroy
  has_one_attached :good_file, :dependent => :destroy
  has_one_attached :bad_file, :dependent => :destroy

  after_create_commit :start_scrubbing
  default_scope { order(created_at: :desc) }


  def start_scrubbing
    ScrubJob.set(wait: 1.second).perform_later(self.id)
  end
end
