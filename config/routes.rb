Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"
  #
  get 'demo', to: 'chat_sessions#show'
  resources :documents, only: [:index, :show] do
    resources :chat_sessions
  end
  resources :inquires, only: [:create, :index]
  get 'hello/world'
end
