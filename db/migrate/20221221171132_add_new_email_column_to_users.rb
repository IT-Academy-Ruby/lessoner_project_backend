class AddNewEmailColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :new_email, :string
  end
end
