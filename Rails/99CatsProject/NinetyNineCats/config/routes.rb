Rails.application.routes.draw do
  resources :users do
    resources :rental_requests, only: [:index]
  end

  resources :cats do
    resources :rental_requests, only: [:index, :new]
  end

  resources :rental_requests, except: [:index]

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  
  root to: 'cats#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
