Datrepo::Application.routes.draw do

  devise_for :users
  ActiveAdmin.routes(self)
  root to: redirect('/about')

  get '/about', to: 'high_voltage/pages#show', id: 'about'
  # get '/search', to: 'search#show'

  resource :search, controller: :search, only: :show do
    get 'autocomplete'
  end

  resources :datasets do
    post 'favorite'
  end

  resources :collections do
    post 'favorite'
  end

  resources :users, only: [:show] do 
    get 'following'
  end
end
