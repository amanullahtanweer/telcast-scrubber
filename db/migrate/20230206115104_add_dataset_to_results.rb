class AddDatasetToResults < ActiveRecord::Migration[7.0]
  def change
    add_column :results, :dataset, :string, default: 'master'
  end
end
