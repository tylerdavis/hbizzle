require 'sidekiq/web'

Rbo::Application.routes.draw do
  
  root 'movies#index'
  resources :movies, only: [:index, :show]

  get '/latest' => 'movies#latest'

  post '/play' => 'movies#play'

  mount Sidekiq::Web => '/sidekiq'

end
