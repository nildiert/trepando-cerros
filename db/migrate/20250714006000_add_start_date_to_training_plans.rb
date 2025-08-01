class AddStartDateToTrainingPlans < ActiveRecord::Migration[7.1]
  def change
    add_column :training_plans, :start_date, :date, null: false, default: Date.current
  end
end
