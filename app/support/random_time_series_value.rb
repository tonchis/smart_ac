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

    def array(n, time, frequency, amplitude, min, max, step = 1.minute)
      prev = self.new(
        time, frequency, amplitude, min, max, 0
      )
      i = 0
      acc = []
      while i < n
        prev = self.from(prev, step)
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

  def peaktime
    time.change(hour: 17)
  end

  def value_slope
    (maxvalue - minvalue) / (12.0 * 60.0 * 60.0)
  end
end
