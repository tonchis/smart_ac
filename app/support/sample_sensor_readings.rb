# frozen_string_literal: true

# This is just a way to organize
# code when creating time series values for
# the sensors. It's only used in the seeds file.
#
module SampleSensorReadings
  class << self
    def create(sensor, number, duration, final_time)
      max_temp = SecureRandom.rand(4.0) + 22.0
      min_temp = SecureRandom.rand(4.0) + 16.0
      frequency = SecureRandom.rand(0.4) + 0.1
      variation = SecureRandom.rand(5.0) + 2.0
      initial_time = final_time - (number * duration)

      temperatures = RandomTimeSeriesValue.array(
        number,
        initial_time,
        frequency,
        variation,
        min_temp,
        max_temp,
        duration
      )

      humiditys = RandomTimeSeriesValue.array(
        number,
        initial_time,
        0.03,
        20.0,
        45.0,
        25.0,
        duration
      )

      number.times.each do |n|
        time = initial_time + n * duration

        sensor.readings << Reading.new(
          temperature: temperatures[n],
          humidity: humiditys[n],
          carbon_monoxide: SecureRandom.rand(10),
          recorded_at: time,
          health_status: 'healthy'
        )
      end
    end
  end
end
