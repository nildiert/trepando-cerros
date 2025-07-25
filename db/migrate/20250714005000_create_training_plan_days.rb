class CreateTrainingPlanDays < ActiveRecord::Migration[7.1]
  def change
    create_table :training_plan_days do |t|
      t.references :training_plan, null: false, foreign_key: true
      t.integer :day, null: false
      # default to rest so blank days don't show as strength
      t.integer :workout_type, null: false, default: 4

      t.timestamps
    end

    add_index :training_plan_days, [:training_plan_id, :day], unique: true
  end
end
