module Admin::UsersHelper
  def sort_columns
    [
      ['Email', 'email'],
      ['Empresa', 'companies.name'],
      ['Nombre', 'complete_name'],
      ['Usuario', 'name']
    ]
  end
end
