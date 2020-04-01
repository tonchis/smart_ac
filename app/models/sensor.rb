# A sensor record
class Sensor < ApplicationRecord
  belongs_to :device
  has_many :readings, dependent: :destroy
  has_one :alert, dependent: :destroy

  validates :sensor_number, uniqueness: {scope: :device_id}
  
end
