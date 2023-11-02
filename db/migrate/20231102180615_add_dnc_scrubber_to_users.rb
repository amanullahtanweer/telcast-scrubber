class AddDncScrubberToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_dnc_scrubber, :boolean
  end
end
