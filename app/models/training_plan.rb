class TrainingPlan < ApplicationRecord
  belongs_to :user
  belongs_to :athlete, class_name: 'User', optional: true

  validates :name, presence: true
end
