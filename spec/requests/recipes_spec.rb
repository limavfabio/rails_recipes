require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  describe 'GET /recipes' do
    it 'returns a list of recipes' do
      recipes = FactoryBot.create_list(:recipe, 5)

      get '/recipes'

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/html')

      recipes.each do |recipe|
        expect(response.body).to include(recipe.name)
        expect(response.body).to include(recipe.preparation_time.to_s)
        expect(response.body).to include(recipe.cooking_time.to_s)
      end
    end
  end

  describe 'GET /recipes/:id' do
    it 'returns a single recipe' do
      recipe = FactoryBot.create(:recipe)

      get "/recipes/#{recipe.id}"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/html')

      expect(response.body).to include(recipe.name)
      expect(response.body).to include(recipe.preparation_time.to_s)
      expect(response.body).to include(recipe.cooking_time.to_s)
    end
  end

  describe 'POST /recipes' do
    it 'creates a new recipe with current_user as owner' do
      user = FactoryBot.create(:user)

      sign_in user

      recipe_params = {
        name: 'Chocolate Cake',
        preparation_time: 30,
        cooking_time: 60,
        description: 'Delicious chocolate cake recipe'
      }

      post '/recipes', params: { recipe: recipe_params }

      expect(response).to have_http_status(:found)

      follow_redirect!

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/html')

      expect(response.body).to include('Chocolate Cake')
      expect(response.body).to include('30')
      expect(response.body).to include('60')
      expect(response.body).to include('Delicious chocolate cake recipe')

      recipe = Recipe.last
      expect(recipe.user).to eq(user)
    end
  end

  describe 'DELETE /recipes/:id' do
    it 'deletes a recipe' do
      user = FactoryBot.create(:user)
      recipe = FactoryBot.create(:recipe, user:)

      sign_in user

      delete "/recipes/#{recipe.id}"

      expect(response).to have_http_status(:found)

      follow_redirect!

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/html')

      expect(response.body).to_not include(recipe.name)
      expect(response.body).to_not include(recipe.description)

      expect(Recipe.count).to eq(0)
    end
  end
end
