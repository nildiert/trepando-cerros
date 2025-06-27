class RolePermission < ApplicationRecord
  belongs_to :role
  validates :name, presence: true
end
