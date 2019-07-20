json.extract! @data, :address, :name, :role_number, :file_number, :file_date, :owner, :legal_agent, :architect, :floors, :undergrounds, :total_units, :total_parking, :total_commercials, :m2_approved, :m2_built, :m2_field, :cadastral_date, :comments, :bimester, :year
json.project_type do 
  json.name @data.project_type.name
end

json.future_project_type do
  json.name @data.future_project_type.name
end
