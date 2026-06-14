class Review < ApplicationRecord
  belongs_to :property

  validates :author, presence: true
  validates :rating, numericality: { in: 1..5 }, allow_nil: true
  validates :body,   presence: true
end
