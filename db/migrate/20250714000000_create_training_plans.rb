class CreateTrainingPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :training_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
  end
end
