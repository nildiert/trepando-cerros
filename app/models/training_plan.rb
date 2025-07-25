class TrainingPlan < ApplicationRecord
  belongs_to :user
  belongs_to :athlete, class_name: 'User', optional: true

  has_many :training_plan_days, dependent: :destroy
  accepts_nested_attributes_for :training_plan_days

  validates :name, presence: true
end
