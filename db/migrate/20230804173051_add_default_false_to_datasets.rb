class AddDefaultFalseToDatasets < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :datasets, from: ['master', 'masteripes', 'masterverizon', 'verizon', 'ipes'].to_yaml, to: ['masteripes', 'masterverizon', 'verizon','ipes'].to_yaml
  end
end
