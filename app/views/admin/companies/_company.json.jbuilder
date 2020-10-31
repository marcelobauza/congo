json.extract! company, :id, :name, :projects_downloads, :transactions_downloads, :future_projects_downloads, :created_at, :updated_at
json.url company_url(company, format: :json)
