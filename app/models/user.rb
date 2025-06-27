class User < ApplicationRecord
  has_one :profile, dependent: :destroy
end
