class QualityCheck < ApplicationRecord
  STATES = %w[progress scheduled approved].freeze

  belongs_to :property

  validates :guest_name, presence: true
  validates :state,      inclusion: { in: STATES }
  validates :pct,        numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
