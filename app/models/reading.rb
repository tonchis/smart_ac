class Reading < ApplicationRecord
  ALERT_HEALTH_STATUSES = [
    :gas_leak,
    :needs_new_filter,
    :needs_service
  ]

  belongs_to :sensor

  after_create :add_alerts_if_required

  private

  def add_alerts_if_required
    alerts = []
    if ALERT_HEALTH_STATUSES.include?(health_status.to_s.to_sym)
      alerts << health_status.to_s.to_sym
    end

    if carbon_monoxide && carbon_monoxide > 9
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
