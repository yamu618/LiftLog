Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  get "contacts/new"
  get "contacts/create"
  get "reports/index"
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
   }

  resources :exercises, only: %i[index edit create update destroy]
  resources :workouts do
    member do
      get :new_set
      post :create_set
      post :copy_previous_sets
    end
  end
  resources :workout_sets, only: %i[edit update destroy]
  resources :reports, only: %i[index]
  resources :contacts, only: %i[new create]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "home/index"

  get "/terms", to: "pages#terms", as: :terms
  get "/privacy", to: "pages#privacy", as: :privacy

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "workouts#index"
end
