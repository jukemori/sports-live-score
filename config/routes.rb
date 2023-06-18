Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'leagues#index'
  resources :leagues, only:[:index, :show, :new, :create] do
    resources :games, only:[:index, :show, :new, :create]
  end
end
