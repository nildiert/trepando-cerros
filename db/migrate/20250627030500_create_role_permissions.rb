class CreateRolePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :role_permissions do |t|
      t.references :role, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :enabled, default: true
      t.timestamps
    end
    add_index :role_permissions, [:role_id, :name], unique: true
  end
end
