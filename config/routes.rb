Tuitcoins::Application.routes.draw do
  resources :users, :only => [:index]

  resources :campaigns, :except => [:show]

  resources :plans, :except => [:show]

  resources :categories, :except => [:show]

  root :to => 'users#index'
end
