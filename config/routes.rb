Rails.application.routes.draw do
  devise_for :users

  resources :recipes, only: [:index, :show, :new, :create, :destroy]
  resources :foods, only: [:index, :new, :create, :destroy]

  get '/public_recipes', to: 'recipes#public_recipes'
  get '/shopping_list', to: 'foods#shopping_list'

  root "recipes#public_recipes"
end
