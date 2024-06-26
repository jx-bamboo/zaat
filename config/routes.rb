Rails.application.routes.draw do
  post "test" => "home#test", :as => "test"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'profile/index'
  get 'profile/my_model'

  resources :order do
    collection do
      get :earn
      get :text_to
      get :picture_to
      get :createorder
    end
  end
  get 'metamask/eth/:address', to: 'metamask#eth'
  get 'profile' => 'metamask#profile', :as => 'profile'
  post 'sign-in' => 'metamask#sign_in', :as => 'sign-in'
  post 'message' => 'metamask#message', :as => 'message'
  post 'sign-out' => 'metamask#sign_out', :as => 'sign-out'

  get "/auth_modal", to: "home#auth_modal"
  match '/auth/:provider/callback', to: 'home#create', via: %i[get post]
  get '/auth/failure', to: 'home#failure'

  # devise_for :users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }

  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
