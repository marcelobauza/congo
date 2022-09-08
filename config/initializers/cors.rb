Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'app.inciti.com', 'localhost:3000'
    resource '*', headers: :any, methods: [:get, :post, :patch, :put]
  end
end
