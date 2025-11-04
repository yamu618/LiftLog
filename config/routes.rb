Rails.application.routes.draw do
  get "reports/index"
  devise_for :users
  resources :exercises, only: %i[index edit create update destroy]
  resources :workouts do
    member do
      get :new_set
      post :create_set
    end
  end
  resources :workout_sets, only: %i[edit update destroy]
  resources :reports, only: %i[index]

  get "home/index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "workouts#index"
end
