# An individual time reading
class Reading < ApplicationRecord
  belongs_to :sensor

  after_create :add_alerts_if_required

  private

  # Should be changed with better alert mechanism
  def add_alerts_if_required
    alerts = []
    if Alert.status_alerts.include?(health_status.to_s.to_sym)
      alerts << health_status.to_s.to_sym
    end

    if carbon_monoxide && carbon_monoxide > Alert.safe_carbon_monoxide
      alerts << :carbon_monoxide_high
    end

    if alerts.present?
      add_alerts(alerts)
    end
  end

  def add_alerts(alerts)
    alert = sensor.alert || sensor.build_alert()

    alert.active = true
    alert_attributes = Hash[alerts.map{|alert| [alert, true]}]
    alert.assign_attributes(alert_attributes)

    alert.save(validate: false)
  end
end
