class TrainingPlanSegment < ApplicationRecord
  belongs_to :training_plan_day

  attribute :phase, :integer
  attribute :objective_type, :integer
  attribute :intensity_type, :integer

  enum :phase,
       {
         warm_up: 0,
         workout: 1,
         rest: 2,
         cool_down: 3,
         interval: 4
       },
       prefix: true

  enum :objective_type,
       {
         distance: 0,
         time: 1,
         heart_rate_zone: 2,
         free: 3
       },
       prefix: true

  enum :intensity_type,
       {
         heart_rate: 0,
         rpe: 1
       },
       prefix: true

  validates :phase, presence: true
  validates :objective_type, presence: true
end
