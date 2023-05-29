require 'rails_helper'

RSpec.describe 'ShoppingLists', type: :request do
  around(:each) do |example|
    ActiveRecord::Base.connection.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  describe 'GET /index' do
    it 'returns the shopping list' do
      user = FactoryBot.create(:user)

      sign_in user

      recipes = FactoryBot.create_list(:recipe, 5, user: user)
      recipes.each do |recipe|
        @foods = FactoryBot.create_list(:food, 5, recipe: recipe, user: user)
      end

      get '/shopping_list'

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/html')

      expect(response.body).to include('Definitely not')

      @foods.each do |food|
        expect(response.body).to include(food.name)
        # expect(response.body).to include("#{food.quantity} #{food.measurement_unit}")
        # expect(response.body).to include(food.price.to_s)
      end
    end
  end
end
