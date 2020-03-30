class Sensor < ApplicationRecord
  belongs_to :device
  has_many :readings

  validates :sensor_number, uniqueness: {scope: :device_id}
end
