class Device < ApplicationRecord
  has_many :sensors
  has_many :readings, through: :sensors

  validates :serial_number, presence: true, uniqueness: true
end
