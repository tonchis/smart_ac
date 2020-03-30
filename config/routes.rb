Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api, as: :api, module: :api do
    resources :data_reports, only: :create
  end
end
