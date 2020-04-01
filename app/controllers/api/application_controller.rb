# The base controller for the api.
# It sets up authentication using the http token.
# 
# The Header 'AUTHORIZATION' needs to be set
# This can be done in rails with: ActionController::HttpAuthentication::Token.encode_credentials("ABCDEFGH")
#
# This should be  "Token token=\"ABCDEFGH\""
#
class Api::ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  # This is the token to use. It should beset as an env
  TOKEN = ENV["API_ACCESS_KEY"]

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end
end