class CreateFunctionPpUf < ActiveRecord::Migration[5.0]
  def change
    create_function :pp_uf
  end
end
