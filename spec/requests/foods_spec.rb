require 'rails_helper'

RSpec.describe 'Foods', type: :request do
  describe 'GET /foods' do
    it 'returns a list of foods' do
      foods = FactoryBot.create_list(:food, 5)

      get '/foods'

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('text/html')

      foods.each do |food|
        expect(response.body).to include(food.name)
      end
    end
  end

  describe 'POST /foods' do
    it 'creates a new food with current_user as owner' do
      user = FactoryBot.create(:user)

      sign_in user

      food_params = {
        name: 'Tomato',
        measurement_unit: 'kg',
        price: 10.0,
        quantity: 3
      }

      post '/foods', params: { food: food_params }

      expect(response).to have_http_status(:found)

      follow_redirect!

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Tomato')

      food = Food.last
      expect(food.user).to eq(user)
    end
  end

  describe 'DELETE /foods/:id' do
    it 'deletes a food' do
      user = FactoryBot.create(:user)

      sign_in user

      food = FactoryBot.create(:food, user:)

      delete "/foods/#{food.id}"

      expect(response).to have_http_status(:found)

      follow_redirect!

      expect(response).to have_http_status(:ok)
      expect(response.body).to_not include(food.name)
    end
  end
end
