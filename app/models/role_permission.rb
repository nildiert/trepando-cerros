class RolePermission < ApplicationRecord
  belongs_to :role

  AVAILABLE_PERMISSIONS = %w[race_predictor training_plan club athletes users].freeze

  validates :name, presence: true

  after_commit :propagate_to_users

  private

  def propagate_to_users
    role.users.find_each do |user|
      perm = user.permissions.find_or_initialize_by(name: name)
      perm.update(enabled: enabled)
    end
  end
end
