class TrainingPlanDay < ApplicationRecord
  belongs_to :training_plan

  enum :workout_type,
       { fuerza: 0, easy_run: 1, long_run: 2, intensidad: 3, descanso: 4 }

  validates :day, inclusion: { in: 0..6 }
  validates :workout_type, presence: true

  DAYS_OF_WEEK = %w[Lunes Martes Mi\u00e9rcoles Jueves Viernes S\u00e1bado Domingo].freeze

  def day_name
    DAYS_OF_WEEK[day]
  end
end
