json.extract! application_status, :id, :name, :description, :user_id,, :polygon, :layer_type, :filters, :created_at, :updated_at
json.url application_status_url(application_status, format: :json)
