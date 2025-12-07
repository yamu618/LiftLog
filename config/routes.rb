Rails.application.routes.draw do
  get "pages/terms"
  get "pages/privacy"
  # 管理画面
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  # Devise（ユーザー認証）
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # 固定ページ
  get "/terms", to: "pages#terms", as: :terms
  get "/privacy", to: "pages#privacy", as: :privacy
  get "/how_to", to: "pages#how_to", as: :how_to

  # リソース
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

  # api
  namespace :api do
    get "exercises", to: "exercises#index"
  end

  # 開発用メール確認
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # その他のページ
  get "home/index"

  # ヘルスチェック・PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # ルート
  root "workouts#index"
end
