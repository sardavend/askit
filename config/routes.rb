Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"
  sitepress_root
  sitepress_pages
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'demo', to: 'chat_sessions#demo'

  resources :documents, only: [:new, :index, :show] do
    resources :chat_sessions do
      resources :inquires, only: [:create, :index]
    end
  end
  get 'hello/world'

end
