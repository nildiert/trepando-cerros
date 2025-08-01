class AddActivityPhaseToTrainingPlanDays < ActiveRecord::Migration[7.1]
  def change
    add_column :training_plan_days, :activity_phase, :integer, null: false, default: 1
  end
end
