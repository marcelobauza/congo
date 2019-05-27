json.extract! import_process, :id, :status, :file_path, :processed, :inserted, :updated, :failed, :user_id, :data_source, :original_filename, :created_at, :updated_at
json.url import_process_url(import_process, format: :json)
