KnowledgeBase::Application.routes.draw do
  resources :characters
  resources :regions
  resources :cities
  resources :groups

  match "home/index" => "home#index", :via => :get, :as => :home
  match "home/index/:password" => "home#index", :via => :get

  root :to => 'home#index'
end
