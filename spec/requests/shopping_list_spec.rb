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
      recipes = FactoryBot.create_list(:recipe, 5, user:)
      FactoryBot.create_list(:food, 5, recipe: recipes.sample, user:)

      get '/shopping_list'

      expect(response).to have_http_status(:found)
      expect(response.content_type).to include('text/html')
    end
  end
end
