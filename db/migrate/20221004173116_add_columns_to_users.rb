class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :phone
      t.integer :gender, default: 0
      t.date :birthday
    end
  end
end
