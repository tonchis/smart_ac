Rails.application.routes.draw do
  authentication_check = Proc.new do |username, password| 
    username == ENV["ADMIN_USER"] && password == ENV['ADMIN_PASSWORD']
  end

  RailsAdmin.config.authenticate_with do
    authenticate_or_request_with_http_basic('Admin', &authentication_check)
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api, as: :api, module: :api do
    resources :data_reports, only: :create
  end

  resources :devices, only: [:show, :index] do
    resource :sensor_readings, only: :show
  end
end
