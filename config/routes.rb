Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"
  #
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'demo', to: 'chat_sessions#show'
  resources :documents, only: [:index, :show] do
    resources :chat_sessions do
      resources :inquires, only: [:create, :index]
    end
  end
  get 'hello/world'
end
