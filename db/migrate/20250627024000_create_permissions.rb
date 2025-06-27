class CreatePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :enabled, default: true
      t.timestamps
    end
    add_index :permissions, [:user_id, :name], unique: true
  end
end
