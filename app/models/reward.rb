class Reward < ApplicationRecord
  belongs_to :user

  validates :tier, presence: true
end
