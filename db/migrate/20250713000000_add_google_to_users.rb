class AddGoogleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :email, :string
    add_column :users, :google_id, :string
    add_index :users, :email, unique: true
    add_index :users, :google_id, unique: true
  end
end
