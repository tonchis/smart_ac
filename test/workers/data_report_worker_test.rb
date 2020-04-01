require 'test_helper'

class DataReportWorkerTest < ActiveSupport::TestCase
  test "it initializes" do
    worker = DataReportWorker.new
  end

  test "it builds new data from a single sensor measurement" do
    data = {
      device: {
        serial_number: "AB123456",
        firmware_version: "12.3.4",
        registration_date: Date.today.to_s
      },
      humidity: "98.9",
      temperature: 20.1234,
      carbon_monoxide: 8,
      health_status: "all_good",
      recorded_at: Time.now.to_s,
      sensor_number: "42"
    }

    data_report = DataReport.create!(data: data)

    worker = DataReportWorker.new
    assert_difference("Reading.count", 1) do
      worker.perform(data_report.id)
    end
    
    reading = worker.readings[0]
    assert reading.persisted?
    assert reading.sensor.persisted?
    assert reading.sensor.device.persisted?

    assert reading.health_status == data[:health_status]
    assert reading.sensor.sensor_number == data[:sensor_number]
    assert reading.sensor.device.serial_number == data.dig(:device, :serial_number)
    assert reading.sensor.device.firmware_version == data.dig(:device, :firmware_version)
    assert reading.sensor.device.registration_date == data.dig(:device, :registration_date)

  end

  test "it builds new data from multiple sensor measurements" do
    device_data = {
      serial_number: "AB123456",
      firmware_version: "12.3.4",
      registration_date: Date.today.to_s

    }

    time = Time.now

    data = [
      {
        device: device_data,
        humidity: "98.9",
        temperature: 20.1234,
        carbon_monoxide: 8,
        health_status: "all_good",
        recorded_at: (time - 10.minutes).to_s,
        sensor_number: "42"
      },
      {
        device: device_data,
        humidity: "99.0",
        temperature: 20.51,
        carbon_monoxide: 7,
        health_status: "all_good",
        recorded_at: (time - 9.minutes).to_s,
        sensor_number: "42"
      },
      {
        device: device_data,
        humidity: "97.0",
        temperature: 19.51,
        carbon_monoxide: 7,
        health_status: "needs_service",
        recorded_at: (time - 9.minutes).to_s,
        sensor_number: "43"
      },
      {
        device: device_data,
        humidity: "1.0",
        temperature: 20.11,
        carbon_monoxide: 7,
        health_status: "fine",
        recorded_at: (time - 8.minutes).to_s,
        sensor_number: "42"
      }
    ]

    data_report = DataReport.create!(data: data)

    worker = DataReportWorker.new
    assert_difference("Reading.count", 4) do
      assert_difference("Sensor.count", 2) do
        assert_difference("Device.count", 1) do
          worker.perform(data_report.id)
        end
      end
    end
  end


  test "it builds new data from multiple sensor measurements and devices" do
    device_1_data = {
      serial_number: "AB123456"
    }

    device_2_data = {
      serial_number: "BB123456"
    }

    time = Time.now

    data = [
      {
        device: device_1_data,
        humidity: "98.9",
        temperature: 20.1234,
        carbon_monoxide: 8,
        health_status: "all_good",
        recorded_at: (time - 10.minutes).to_s,
        sensor_number: "42"
      },
      {
        device: device_2_data,
        humidity: "99.0",
        temperature: 20.51,
        carbon_monoxide: 7,
        health_status: "all_good",
        recorded_at: (time - 9.minutes).to_s,
        sensor_number: "42"
      },
      {
        device: device_1_data,
        humidity: "97.0",
        temperature: 19.51,
        carbon_monoxide: 7,
        health_status: "needs_service",
        recorded_at: (time - 9.minutes).to_s,
        sensor_number: "43"
      },
      {
        device: device_2_data,
        humidity: "1.0",
        temperature: 20.11,
        carbon_monoxide: 7,
        health_status: "fine",
        recorded_at: (time - 8.minutes).to_s,
        sensor_number: "42"
      }
    ]

    data_report = DataReport.create!(data: data)

    worker = DataReportWorker.new
    assert_difference("Reading.count", 4) do
      assert_difference("Sensor.count", 3) do
        assert_difference("Device.count", 2) do
          worker.perform(data_report.id)
        end
      end
    end
  end
end