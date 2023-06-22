Rails.application.routes.draw do
  # get 'inquires/create'
  # get 'inquires/index'
  # get 'documents/show'
  get 'demo', to: 'documents#show'
  resources :documents, only: [:index, :show]
  resources :inquires, only:[:create, :index]
  get 'hello/world'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
