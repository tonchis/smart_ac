class Api::DataReportsController < Api::ApplicationController
  rescue_from ActionController::ParameterMissing do |exception|
    render json: {errors: [exception.message]}, status: :unprocessable_entity
  end

  # Saves the incoming data report to be processed later
  def create
    data_report = DataReport.new(data_report_params)

    # For now the worker is synchronous. Eventually it can be run asynchronously
    if data_report.save && report_worker.perform(data_report.id)
      render json: {}, status: :ok
    elsif data_report.errors.present
      render json: data_report.errors, status: :unprocessable_entity
    else
      render json: {}, status: :internal_server_error
    end
  end

  private

  def data_report_params
    params.require(:data).require(:device).require(:serial_number)
    params.permit(permitted_data)
  end

  def permitted_data
    {data: [:humidity, :temperature, :carbon_monoxide, :health_status, :recorded_at, :sensor_number, {device: [:serial_number, :registration_date, :firmware_version]}]}
  end

  def report_worker
    @report_worker ||= DataReportWorker.new
  end
end
