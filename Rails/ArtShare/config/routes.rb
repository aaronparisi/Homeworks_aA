Rails.application.routes.draw do
  resources :users do
    resources :artworks, only: [:index]
    resources :comments, only: [:index], as: :authored_comments, path: :authored_comments
  end

  resources :artworks, except: [:index] do
    resources :artist, only: [:index], source: :user
    resources :comments, only: [:index]
  end

  resources :comments, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
