class CreateUsersAndProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.boolean :admin, default: false
      t.timestamps
    end

    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :athlete_id
      t.timestamps
    end
  end
end
