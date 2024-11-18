Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "activities#index"

  resources :students

  # Allowing custom action for unapproved 
  resources :activities do # Changed this to a block
    resources :registrations, only: [:new, :create] # ANNA CHECK
    collection do
      get 'unapproved'
    end

    member do
      patch 'accept'
      patch 'decline'
      get 'accept'
      get 'decline'
    end
  end
end
