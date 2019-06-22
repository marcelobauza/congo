class CreateFunctionCountyName < ActiveRecord::Migration[5.0]
  def change
    create_function :county_name
  end
end
