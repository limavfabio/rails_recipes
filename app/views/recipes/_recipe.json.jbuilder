json.extract! recipe, :id, :name, :preparation_time, :cooking_time, :description, :public, :created_at, :updated_at,
              :user_id
json.url recipe_url(recipe, format: :json)
