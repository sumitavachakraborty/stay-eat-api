class Property < ApplicationRecord
  belongs_to :host, class_name: "User", foreign_key: :host_id, optional: true

  has_many :bookings, dependent: :destroy
  has_many :quality_checks, dependent: :destroy
  # NOTE: the `reviews` integer column holds the review COUNT shown in the UI,
  # so the Review records association is named :property_reviews to avoid
  # shadowing that column's attribute accessor.
  has_many :property_reviews, class_name: "Review", dependent: :destroy

  validates :name,  presence: true
  validates :place, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
