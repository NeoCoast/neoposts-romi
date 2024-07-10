Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "posts#index"

  resources :posts, only: [:show, :new, :create, :destroy]

  get 'users/:nickname', to: 'users#show', as: 'show_user', nickname: /[^\/]+/
  resources :users, only: [:index]

  resources :relationships, only: [:create, :destroy]

  resources :comments, only: [:create]

  resources :likes, only: [:create, :destroy]

  namespace :api do
    namespace :v1, defaults: { format: 'json' } do
      mount_devise_token_auth_for 'User', at: 'auth'

      resources :users, only: [:index] do
        resources :posts, only: [:index, :create]
      end

      resources :posts, only: [:show]
    end
  end
end
