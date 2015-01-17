Tuitcoins::Application.routes.draw do
  resources :users, :only => [:index, :show]

  resources :campaigns, :except => [:show]

  resources :plans, :except => [:show]

  resources :categories, :except => [:show]
  
  resources :dashboards, :only => [:index]
  
  match "/auth/:provider/callback" => "sessions#callback"
  match "/numberaffinity" => "sessions#numberaffinity", :as => "numberaffinity"
  match "/cloudtag" => "sessions#cloudtag", :as => "cloudtag"
  match "/logout" => "sessions#destroy", :as => "logout"

  root :to => 'dashboards#index'
end
