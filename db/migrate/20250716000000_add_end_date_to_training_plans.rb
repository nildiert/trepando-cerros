class AddEndDateToTrainingPlans < ActiveRecord::Migration[7.1]
  def change
    add_column :training_plans, :end_date, :date
  end
end
