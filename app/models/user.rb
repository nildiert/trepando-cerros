class User < ApplicationRecord
  belongs_to :role, optional: true
  has_one :profile, dependent: :destroy
  has_many :permissions, dependent: :destroy
  has_many :training_plans, dependent: :destroy
  has_many :coachings, foreign_key: :coach_id, dependent: :destroy
  has_many :trainees, through: :coachings, source: :athlete
  has_many :inverse_coachings, class_name: 'Coaching', foreign_key: :athlete_id, dependent: :destroy
  has_many :coaches, through: :inverse_coachings, source: :coach

  def permission_enabled?(name)
    permissions.find_by(name: name)&.enabled?
  end
end
