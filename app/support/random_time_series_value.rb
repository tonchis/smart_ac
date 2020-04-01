# frozen_string_literal: true

# Method of creating realisticish time series values
# If adds a random osciallating value to a base daily
# change.
#
# Best to access it throught the array class method.
#
class RandomTimeSeriesValue
  attr_reader :time, :frequency, :amplitude, :previous_phase, :minvalue, :maxvalue, :random_phase

  # frequency should be less than 2
  def initialize(time, frequency, amplitude, minvalue, maxvalue, previous_phase)
    @time = time
    @frequency = frequency
    @amplitude = amplitude
    @previous_phase = previous_phase
    @minvalue = minvalue
    @maxvalue = maxvalue
    @random_phase = SecureRandom.rand(2 * frequency)
  end

  class << self
    # Creates a new time value from an earlier time value
    # Most of the attribute are read from the passed
    # object.
    # The time step is applied when generating the next value
    #
    def from(element, step = 1.minute)
      self.new(
        element.time + step,
        element.frequency,
        element.amplitude,
        element.minvalue,
        element.maxvalue,
        element.previous_phase
      )
    end

    # Easiest interface to use
    # You can generate a list of n values e.g.
    # RandomTimeSeriesValue.array(
    #   3 * 100,
    #   initial_time,
    #   0.03,
    #   20.0,
    #   45.0,
    #   25.0,
    #   100
    # )
    # will create 300 values over 100 days. The base values will
    # be between 25 and 45 with an additional random osciallation
    # of 20.
    def array(n, time, frequency, amplitude, min, max, step = 1.minute)
      prev = self.new(
        time, frequency, amplitude, min, max, 0
      )
      i = 0
      acc = []
      while i < n
        prev = from(prev, step)
        acc << prev.value
        i += 1
      end

      acc
    end
  end

  def value
    @value ||= (base_value + random_variation)
  end

  def random_variation
    previous_phase + amplitude * Math.cos(current_phase)
  end

  def current_phase
    @current_phase ||= (previous_phase + random_phase) % 2.0
  end

  def base_value
    maxvalue - (value_slope * (peaktime - time).abs)
  end

  # At the moment all of the values peak at 5pm
  # and are lowest at 5am.
  def peaktime
    time.change(hour: 17)
  end

  def value_slope
    (maxvalue - minvalue) / (12.0 * 60.0 * 60.0)
  end
end
