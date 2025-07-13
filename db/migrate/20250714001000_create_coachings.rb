class CreateCoachings < ActiveRecord::Migration[7.1]
  def change
    create_table :coachings do |t|
      t.references :coach, null: false, foreign_key: { to_table: :users }
      t.references :athlete, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :coachings, [:coach_id, :athlete_id], unique: true
  end
end
