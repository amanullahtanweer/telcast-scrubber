class AddAllowedDatasetToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :datasets, :string, default: ['master', 'masteripes', 'masterverizon', 'verizon', 'ipes'].to_yaml
  end
end
