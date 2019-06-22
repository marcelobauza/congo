class CreateFunctionMasd < ActiveRecord::Migration[5.0]
  def change
    create_function :masd
  end
end
