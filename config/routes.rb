Rails.application.routes.draw do
  devise_for :users

  resources :recipes, only: %i[index show new create destroy]
  resources :foods, only: %i[index new create destroy]

  get '/public_recipes', to: 'recipes#public_recipes'
  get '/shopping_list', to: 'shopping_list#index'

  root 'recipes#index'
end
