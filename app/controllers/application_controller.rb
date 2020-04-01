class ApplicationController < ActionController::Base
  before_action :authenticate

  # Authenticate with basic http authenctication
  # It looks up a user by the email and then authenticates the password
  def authenticate
    authenticate_or_request_with_http_basic('Application') do |email, password|
      user = User.find_by_email(email)

      if user.present?
        user.authenticate(password)
      end
    end
  end
end
