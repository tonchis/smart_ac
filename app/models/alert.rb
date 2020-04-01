# Provides alerts for sensors
# Eash sensor has one or none. 
# The should be set to active when new alerts
# are created. When alerts are dismissed
# they can have all their boolean fields
# set to nil
# 
# This is probably not the best way to handle alerting
# but it's the most efficient
class Alert < ApplicationRecord
  ALERT_ON_HEALTH_STATUSES = [
    :gas_leak,
    :needs_new_filter,
    :needs_service
  ]

  ALERT_ON_CARBON_MONOXIDE = 9

  belongs_to :sensor

  scope :active, ->{ where(active: true) }

  class << self
    def status_alerts
      ALERT_ON_HEALTH_STATUSES
    end

    def safe_carbon_monoxide
      ALERT_ON_CARBON_MONOXIDE
    end
  end
end
