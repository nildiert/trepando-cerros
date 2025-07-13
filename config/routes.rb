Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  resources :athletes, only: [:show] do
    resource :training, only: [:show]
    resource :settings, only: [:show, :update]
  end
  resources :roles, only: [:show, :update]
  post "athletes/:id" => "athletes#show"

  get "/auth/strava" => "sessions#connect", as: :strava_connect
  get "/auth/strava/callback" => "sessions#callback", as: :strava_callback
  delete "/auth/strava" => "sessions#disconnect", as: :strava_disconnect
  delete "/logout" => "sessions#destroy", as: :logout
end
