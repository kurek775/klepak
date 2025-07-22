Rails.application.routes.draw do
  # Login routes
  get "/login", to: "login#new"
  get "home", to: "home#index", as: :home

  post "/oauth/google_oauth2", to: "login#create"

  # Main app logic
  resources :users

  # OAuth callback namespace (if needed by Omniauth)
  namespace :oauth do
    namespace :google_oauth2 do
      get "callback"
    end
  end

  # Root path
  root "login#new" # or "home#index" if you want a different root for logged-in users

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
