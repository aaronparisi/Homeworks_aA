Rails.application.routes.draw do
  resources :users

  controller :sessions do
    get '/login', to: 'sessions#new', as: 'login'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy', as: 'logout'
  end

  resources :bands do
    resources :albums, except: [:show, :destroy]
  end

  resources :albums, only: [:show, :destroy] do
    resources :tracks, except: [:show]
  end

  resources :tracks, only: [:show]

  root to: 'bands#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
