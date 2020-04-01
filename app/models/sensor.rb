# A sensor record
class Sensor < ApplicationRecord
  belongs_to :device
  has_many :readings
  has_one :alert

  validates :sensor_number, uniqueness: {scope: :device_id}
  
end
