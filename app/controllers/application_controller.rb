class ApplicationController < ActionController::Base
  before_action :authenticate

  def authenticate
    authenticate_or_request_with_http_basic('Application') do |email, password|
      # username == 'admin' && password == 'password'
      user = User.find_by_email(email)

      if user.present?
        user.authenticate(password)
      end
    end
  end
end
