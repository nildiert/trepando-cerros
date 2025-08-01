class TrainingPlan < ApplicationRecord
  belongs_to :user
  belongs_to :athlete, class_name: 'User', optional: true

  has_many :training_plan_days, dependent: :destroy
  accepts_nested_attributes_for :training_plan_days, allow_destroy: true

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  before_validation :set_default_dates, on: :create

  def date_for(day_index)
    return nil unless start_date

    start_date + day_index
  end

  private

  def set_default_dates
    self.start_date ||= Date.current.beginning_of_week(:monday)
    self.end_date ||= start_date&.end_of_week(:sunday)
  end
end
