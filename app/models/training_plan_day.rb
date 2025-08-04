class TrainingPlanDay < ApplicationRecord
  belongs_to :training_plan

  enum :workout_type,
       {
         strength: 0,
         easy_run: 1,
         long_run: 2,
         intensity: 3,
         rest: 4,
         cross_training: 5
       },
       prefix: true

  has_many :segments, class_name: 'TrainingPlanSegment', dependent: :destroy, inverse_of: :training_plan_day
  accepts_nested_attributes_for :segments, allow_destroy: true

  validates :day, inclusion: { in: 0..6 }
  validates :workout_type, presence: true

  DAYS_OF_WEEK = %w[Lunes Martes Miércoles Jueves Viernes Sábado Domingo].freeze

  def day_name
    DAYS_OF_WEEK[day]
  end

  def date
    training_plan&.date_for(day)
  end
end
