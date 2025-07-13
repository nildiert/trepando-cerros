Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  resource :training, only: [:show]
  resource :settings, only: [:show, :update]
  resources :athletes, only: [:show] do
    resource :training, only: [:show]
    resource :settings, only: [:show, :update]
  end
  get "/race_predictor" => "athletes#show", as: :race_predictor
  get "/dashboard" => "dashboard#show", as: :dashboard
  resources :roles, only: [:show, :update, :create]
  resources :training_plans, only: [:index, :new, :create, :show]
  resources :coaches, only: [:index]
  resources :users, only: [:index, :edit, :update]
  post "athletes/:id" => "athletes#show"

  get "/auth/strava" => "sessions#connect", as: :strava_connect
  get "/auth/strava/callback" => "sessions#callback", as: :strava_callback
  get "/auth/google" => "sessions#google_connect", as: :google_connect
  get "/auth/google_oauth2/callback" => "sessions#google_callback", as: :google_callback
  delete "/auth/strava" => "sessions#disconnect", as: :strava_disconnect
  delete "/logout" => "sessions#destroy", as: :logout
end
