class Experience < ApplicationRecord
  validates :slug,      presence: true, uniqueness: true
  validates :name,      presence: true
  validates :host_name, presence: true
end
