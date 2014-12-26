Tuitcoins::Application.routes.draw do
  resources :users, :only => [:index, :new, :show]

  resources :campaigns, :except => [:show]

  resources :plans, :except => [:show]

  resources :categories, :except => [:show]
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/logout" => "sessions#destroy", :as => "logout"

  root :to => 'users#index'
end
