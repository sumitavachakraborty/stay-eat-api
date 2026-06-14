Rails.application.routes.draw do
  # Health check (Rails 8 built-in)
  get "/up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # Public catalog endpoints
      resources :properties, only: %i[index show]
      resources :categories, only: %i[index]
      resources :experiences, only: %i[index]

      # Auth endpoints — all handled by Api::V1::AuthController
      scope :auth do
        post "signup", to: "auth#signup"
        post "login",  to: "auth#login"
        get  "me",     to: "auth#me"
      end

      # Traveller bookings (authenticated)
      resources :bookings, only: %i[index create]

      # Host-only dashboard endpoints
      namespace :host do
        get  "analytics",    to: "analytics#show"
        resources :listings, only: %i[index create]
        resources :quality_checks, only: %i[index show]
      end
    end
  end
end
