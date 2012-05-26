KnowledgeBase::Application.routes.draw do
  resources :characters
  resources :regions
  resources :cities
  resources :groups

  get "home/index"

  root :to => 'home#index'
end
