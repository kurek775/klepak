json.extract! user, :id, :name, :email, :role, :team, :created_at, :updated_at
json.url user_url(user, format: :json)
