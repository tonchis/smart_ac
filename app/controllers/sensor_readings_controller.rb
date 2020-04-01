class SensorReadingsController < ApplicationController

  def show
    readings = SensorReadingDisplay.new(device.sensors, reading_attribute, end_time, range)
    render json: readings.to_h.chart_json
  end

  private

  def range
    params[:range].to_i
  end

  def end_time
    Time.at(params[:end_time].to_i)
  end

  def reading_attribute
    params[:attribute]
  end

  def device
    @device ||= Device.find(params[:device_id])
  end

  class SensorReadingDisplay
    attr_reader :sensor_scope, :range, :end_time, :attribute

    def initialize(sensor_scope, attribute, end_time, range)
      @sensor_scope = sensor_scope
      @attribute = attribute.to_sym
      @range = range
      @end_time = end_time
    end

    def to_h
      sensor_scope.map do |sensor|
        {
          name: ["Sensor", sensor.sensor_number].join(" "), 
          data: sensor.readings.where(recorded_at_scope).group_by_period(time_bucket, :recorded_at).average(attribute)
        }
      end
    end

    def to_json(context=nil)
      to_h.to_json(context)
    end

    def recorded_at_scope
      Reading.arel_table[:recorded_at].lt(end_time).and(Reading.arel_table[:recorded_at].gt(start_time))
    end

    def start_time
      end_time - range
    end

    def time_bucket
      case
      when range <= 4.hours then
        :minute
      when range <= 3.days then
        :hour
      else
        :day
      end
    end
  end
end
