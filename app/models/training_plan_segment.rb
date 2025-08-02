class TrainingPlanSegment < ApplicationRecord
  belongs_to :training_plan_day

  enum phase: {
    warm_up: 0,
    workout: 1,
    rest: 2,
    cool_down: 3,
    interval: 4
  }, _prefix: true

  validates :phase, presence: true
end
