Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  get "athletes/lookup" => "athletes#lookup"
  resources :athletes, only: [:show]
  post "athletes/:id" => "athletes#show"
end
