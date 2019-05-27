class CreateFunctionCleangeometry < ActiveRecord::Migration[5.0]
  def change
    create_function :cleangeometry
  end
end
