class RolePermission < ApplicationRecord
  belongs_to :role

  AVAILABLE_PERMISSIONS = %w[race_predictor training_plan club athletes users].freeze

  validates :name, presence: true
end
