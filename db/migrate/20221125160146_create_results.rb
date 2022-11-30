class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :rows
      t.integer :good_rows
      t.integer :bad_rows
      t.integer :invalid_rows
      t.integer :csv_column
      t.string :job_status
      t.datetime :finished_at

      t.timestamps
    end
  end
end
