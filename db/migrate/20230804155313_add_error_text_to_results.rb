class AddErrorTextToResults < ActiveRecord::Migration[7.0]
  def change
    add_column :results, :error_text, :text
  end
end
