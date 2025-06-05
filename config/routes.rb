Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
  resources :athletes, only: [:show]
  post "athletes/:id" => "athletes#show"
end
