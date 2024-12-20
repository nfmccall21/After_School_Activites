Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    unlocks: "users/unlocks",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
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

  resources :registrations

  # approve/deny routes for registration
  put "/registrations/:id/approve", to: "registrations#approve", as: "registration_approve"
  put "/registrations/:id/decline", to: "registrations#decline", as: "registration_decline"

  get "/moderateusers", to: "users#moderate", as: "moderate_users"
  post "/users/:id/makeadmin", to: "users#make_admin", as: "user_make_admin"
  post "/users/:id/maketeacher", to: "users#make_teacher", as: "user_make_teacher"
  post "/users/:id/makeparent", to: "users#make_parent", as: "user_make_parent"
  # Allowing custom action for unapproved
  resources :activities do # Changed this to a block
    resources :registrations, only: [ :new, :create, :delete ]
    collection do
      get "unapproved"
    end

    member do
      patch "accept"
      patch "decline"
      post "register"
    end
  end
end
