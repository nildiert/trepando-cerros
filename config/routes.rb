Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  resources :athletes, only: [:show]
  get "athletes/:id/nutrition" => "athletes#nutrition", as: :nutrition_athlete, defaults: { format: :pdf }
  post "athletes/:id" => "athletes#show"

  get "/auth/strava" => "sessions#connect", as: :strava_connect
  get "/auth/strava/callback" => "sessions#callback", as: :strava_callback
  delete "/logout" => "sessions#destroy", as: :logout
end
