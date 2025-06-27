class Role < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :role_permissions, dependent: :destroy

  def admin?
    name == 'admin'
  end
end
