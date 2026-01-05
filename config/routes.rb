Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  # Dashboard routes
  resources :widgets do
    get :preview, on: :member
    resources :questions, module: :widgets
    resource :analytics, only: [ :show ], module: :widgets
  end

  get "/analytics", to: "analytics#index", as: :analytics

  # Public survey form (using slug instead of ID)
  get "/forms/:slug", to: "forms#show", as: :widget_form
  post "/forms/:slug/submit", to: "forms#submit", as: :submit_widget_form
  get "/forms/:slug/thank_you", to: "forms#thanks", as: :thank_you_widget_form
  resource :subscription, only: [ :show, :create ]  # subscriptions management (singular resource)
  resources :products, only: [ :index ]  # products management

  get "/profile", to: "profile#show", as: :profile
  get "/profile/edit", to: "profile#edit", as: :edit_profile
  patch "/profile", to: "profile#update", as: :update_profile
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "page#welcome"
end
