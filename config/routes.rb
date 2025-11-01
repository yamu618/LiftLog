Rails.application.routes.draw do
  devise_for :users
  resources :exercises, only: %i[index edit create update destroy]

  get "home/index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "home#index"
end
