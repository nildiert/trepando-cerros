class Club < ApplicationRecord
  has_many :users, dependent: :nullify

  def coaches
    users.joins(:role).where(roles: { name: 'trainer' })
  end
end
