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

    get '/members', to: 'users#index', as: 'members'
    get '/add_members', to: 'band_memberships#new', as: 'member_add'
    post '/add_members', to: 'band_memberships#create'
    delete '/member/:member_id', to: 'band_memberships#destroy', as: 'member_leave'

    post '/like', to: 'bands#like', as: 'like'
    delete 'unlike', to: 'bands#unlike', as: 'unlike'
  end

  resources :albums, only: [:show, :destroy] do
    resources :tracks, except: [:show]

    post '/like', to: 'albums#like', as: 'like'
    delete 'unlike', to: 'albums#unlike', as: 'unlike'
  end

  resources :tracks, only: [:show, :destroy] do
    post '/like', to: 'tracks#like', as: 'like'
    delete 'unlike', to: 'tracks#unlike', as: 'unlike'
  end

  root to: 'users#welcome'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
