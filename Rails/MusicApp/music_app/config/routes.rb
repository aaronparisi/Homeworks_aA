Rails.application.routes.draw do

  resources :users, except: [:index] do
    resources :bands, except: [:show]
  end

  controller :sessions do
    get '/login', to: 'sessions#new', as: 'login'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy', as: 'logout'
  end

  resources :bands, only: [:index, :show] do
    resources :albums, except: [:show, :destroy]
    
    post '/like', to: 'likes#create', as: 'like'
    delete '/like', to: 'likes#destroy', as: 'unlike'

    get '/members', to: 'users#index', as: 'members'
    get '/add_members', to: 'band_memberships#new', as: 'member_add'
    post '/add_members', to: 'band_memberships#create'
    delete '/member/:member_id', to: 'band_memberships#destroy', as: 'member_leave'
  end

  resources :albums, only: [:show, :destroy] do
    resources :tracks, except: [:show]
  end

  resources :tracks, only: [:show, :destroy]

  root to: 'users#welcome'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
