Rails.application.routes.draw do
  resources :users do
    resources :artworks, only: [:index]
    resources :comments, only: [:index], as: :authored_comments, path: :authored_comments
    resources :likes, only: [:index], as: :made_likes, path: :made_likes
  end

  resources :artworks, except: [:index] do
    resources :artist, only: [:index], source: :user
    resources :comments, only: [:index]
    resources :likes, only: [:index]
  end

  resources :comments, only: [:create, :destroy]
  resources :likes, only: [:create, :destory]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
