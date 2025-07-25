class CreateTrainingPlanDays < ActiveRecord::Migration[7.1]
  def change
    create_table :training_plan_days do |t|
      t.references :training_plan, null: false, foreign_key: true
      t.integer :day, null: false
      t.integer :workout_type, null: false, default: 0

      t.timestamps
    end

    add_index :training_plan_days, [:training_plan_id, :day], unique: true
  end
end
