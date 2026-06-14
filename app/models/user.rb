class User < ApplicationRecord
  has_secure_password

  ROLES = %w[traveller host].freeze

  has_many :bookings, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :properties, foreign_key: :host_id, dependent: :nullify, inverse_of: :host

  validates :name,  presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role,  inclusion: { in: ROLES }

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase.strip if email.present?
  end
end
