Rails.application.routes.draw do
  # Use Devise with custom omniauth callbacks

  resources :records


  namespace :oauth do
    namespace :google_oauth2 do
      get "callback"
    end
  end

  # You can use home#index or records#index as the landing page
  # get "home/index"
  root "home#index"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Optional PWA routes (commented out by default)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
