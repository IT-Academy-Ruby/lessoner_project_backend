class AddColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :full_name
      t.string :uid
      t.string :avatar_url
      t.string :provider
    end
  end
end
