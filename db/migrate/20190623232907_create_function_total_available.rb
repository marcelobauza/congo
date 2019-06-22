class CreateFunctionTotalAvailable < ActiveRecord::Migration[5.0]
  def change
    create_function :total_available
  end
end
