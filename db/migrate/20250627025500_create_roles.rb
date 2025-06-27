class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_reference :users, :role, foreign_key: true
  end
end
