class Coaching < ApplicationRecord
  belongs_to :coach, class_name: 'User'
  belongs_to :athlete, class_name: 'User'
end
