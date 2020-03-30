class Device < ApplicationRecord
  has_many :sensors

  validates :serial_number, presence: true, uniqueness: true
end
