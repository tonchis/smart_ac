class DevicesController < ApplicationController
  helper_method :devices, :device, :chart_end_time, :active_device_alerts

  def index
  end

  def show
  end

  private

  def device
    @device ||= Device.find(params[:id])
  end

  def devices
    @devices ||= Device.order(created_at: :desc).all
  end

  def active_device_alerts
    device.alerts.active
  end

  #  The current end time is just the last reading time 
  #  This is purely to make demos easier. It should be converted
  #  to a parameter based time.
  def chart_end_time
    @chart_end_time ||= device.readings.order(:recorded_at).last.try(:recorded_at).to_i
  end
end
