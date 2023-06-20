Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'leagues#index'
  resources :leagues, only:[:index, :show] do
    resources :teams, only:[:index, :show]
  end
end
