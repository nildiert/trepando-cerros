class CreateTrainingPlanSegments < ActiveRecord::Migration[7.1]
  def change
    create_table :training_plan_segments do |t|
      t.references :training_plan_day, null: false, foreign_key: true
        t.integer :phase, null: false
        t.integer :objective_type, null: false
        t.integer :duration
        t.decimal :distance, precision: 6, scale: 2
        t.integer :hr_zone
        t.integer :intensity_type
        t.integer :intensity_from
        t.integer :intensity_to
        t.integer :position

      t.timestamps
    end
  end
end
