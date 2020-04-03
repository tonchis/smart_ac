class DataReportWorker
  attr_reader :data_report, :readings

  def perform(data_report_id)
    @data_report = DataReport.find(data_report_id)

    create_data!
    readings.all?(&:persisted?)
  end

  private
  
  def create_data!
    case report_data
    when Hash then
      report = build_sensor_data(report_data)
      save_records!(report)
    when Array then
      reports = report_data.map{|d| build_sensor_data(d)}
      save_records!(*reports)
    end
  end

  def report_data
    data_report.data
  end

  def build_sensor_data(data)
    serial_number = serial_number_for(data)
    sensor_number = sensor_number_for(data)

    device = get_device_by_serial_number(data, serial_number)
    sensor = get_sensor_by_serial_number_and_sensor_number(
      data, device, sensor_number, serial_number
    )

    sensor.readings.new(reading_data_for(data))
  end

  def save_records!(*readings)
    @readings = readings

    Reading.transaction do
      readings.map(&:save!)
    end
  end

  def sensor_number_for(data)
    data["sensor_number"]
  end

  def serial_number_for(data)
    device_attributes_for(data).dig("serial_number")
  end

  def device_attributes_for(data)
    data.dig("device")
  end

  def reading_data_for(data)
    data.slice("temperature", "humidity", "carbon_monoxide", "health_status", "recorded_at")
  end

  def get_sensor_by_serial_number_and_sensor_number(data, device, sensor_number, serial_number)
    if @sensors.nil?
      @sensors = {}
    end

    identifier = [serial_number, sensor_number].join("--")

    @sensors[identifier] ||= device.sensors.find_or_initialize_by(sensor_number: sensor_number) do |sensor|

    end
  end

  def get_device_by_serial_number(data, serial_number)
    if @devices.nil?
      @devices = {}
    end

    @devices[serial_number] ||= Device.find_or_initialize_by(serial_number: serial_number) do |device|
      device_attributes = device_attributes_for(data)

      device.assign_attributes(device_attributes)
    end
  end
end