class TrainingPlanDay < ApplicationRecord
  belongs_to :training_plan

  enum :workout_type,
       {
         strength: 0,
         easy_run: 1,
         long_run: 2,
         intensity: 3,
         rest: 4
       },
       prefix: true

  enum :activity_phase,
       {
         warm_up: 0,
         workout: 1,
         rest: 2,
         cool_down: 3,
         interval: 4
       },
       prefix: true

  validates :day, inclusion: { in: 0..6 }
  validates :workout_type, presence: true
  validates :activity_phase, presence: true

  DAYS_OF_WEEK = %w[Lunes Martes Miércoles Jueves Viernes Sábado Domingo].freeze

  def day_name
    DAYS_OF_WEEK[day]
  end

  def date
    training_plan&.date_for(day)
  end
end
