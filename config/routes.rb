require 'sidekiq/web'

Rbo::Application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'movies#index'
  resources :movies, only: [:index, :show]

  get '/latest' => 'movies#latest'

  post '/play' => 'movies#play'

  mount Sidekiq::Web => '/sidekiq'

end
