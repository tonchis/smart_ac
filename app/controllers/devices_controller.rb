class DevicesController < ApplicationController
  helper_method :devices, :device, :chart_end_time

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

  def chart_end_time
    @chart_end_time ||= device.readings.order(:recorded_at).last.try(:recorded_at).to_i
  end
end
