class Booking < ApplicationRecord
  STATUSES = %w[confirmed pending cancelled].freeze

  belongs_to :user
  belongs_to :property

  validates :check_in,  presence: true
  validates :check_out, presence: true
  validates :guests,    numericality: { greater_than: 0 }, allow_nil: true
  validates :status,    inclusion: { in: STATUSES }

  validate :check_out_after_check_in

  private

  def check_out_after_check_in
    return unless check_in && check_out

    errors.add(:check_out, "must be after check-in date") if check_out <= check_in
  end
end
