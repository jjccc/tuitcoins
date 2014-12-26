Tuitcoins::Application.routes.draw do
  resources :users, :only => [:index, :new]

  resources :campaigns, :except => [:show]

  resources :plans, :except => [:show]

  resources :categories, :except => [:show]
  
  match "/auth/:provider/callback" => "sessions#create" 

  root :to => 'users#index'
end
