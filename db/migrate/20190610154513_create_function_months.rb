class CreateFunctionMonths < ActiveRecord::Migration[5.0]
  def change
    create_function :months
  end
end
