Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  resources :athletes, only: [:show]
  post "athletes/:id" => "athletes#show"

  get "/auth/strava" => "sessions#connect", as: :strava_connect
  get "/auth/strava/callback" => "sessions#callback", as: :strava_callback
end
