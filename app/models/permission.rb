class Permission < ApplicationRecord
  belongs_to :user

  AVAILABLE_PERMISSIONS = RolePermission::AVAILABLE_PERMISSIONS

  validates :name, presence: true
end
