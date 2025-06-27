class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :permissions, dependent: :destroy

  def permission_enabled?(name)
    permissions.find_by(name: name)&.enabled?
  end
end
