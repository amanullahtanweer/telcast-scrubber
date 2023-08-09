class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :parent_user_id, :integer
    add_column :users, :is_reseller, :boolean
  end
end
