require 'test_helper'

class Api::DataReportsControllerTest < ActionDispatch::IntegrationTest
  def headers
    { 
      'AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials("ABCDEFGH")
    }
  end

  test "posting a new report saves the data" do
    data = {
      device: {
        serial_number: "YXG1122334455"
      },
      humidity: "98.9",
      temperature: 20.1234,
      carbon_monoxide: 8,
      health_status: "all_good",
      recorded_at: Time.now.iso8601,
      sensor_number: "42"
    }

    envelope = {
      data: data
    }

    post api_data_reports_path(envelope), headers: headers
    assert_response :success

    new_record_data = DataReport.last.data
    assert data[:humidity] == new_record_data["humidity"]
    assert data[:temperature] == new_record_data["temperature"].to_f
    assert data[:carbon_monoxide] == new_record_data["carbon_monoxide"].to_i
    assert data[:health_status] == new_record_data["health_status"]
    assert data[:sensor_number].to_i == new_record_data["sensor_number"].to_i
    assert data[:recorded_at] == new_record_data["recorded_at"]

    assert data[:device][:serial_number] == new_record_data["device"]["serial_number"]
  end

  test "if data key is missing it responds with an error" do
    post api_data_reports_path({other_key: "is missing"}), headers: headers
    
    assert_response :unprocessable_entity
  end

  test "responds with an error if serial number is missing" do
    post api_data_reports_path({data: {device: {foo: "bar"}}}), headers: headers
    
    assert_response :unprocessable_entity
  end
end
