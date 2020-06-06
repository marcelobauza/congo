class ProjectType < ApplicationRecord
 has_many :projects
 has_many :future_projects

  DEPARTMENTS = "Departamentos"
  HOUSES = "Casas"

  def self.get_project_type_by_first_letter(projtype)
    case projtype
    when "B"
      p_type = ProjectType.find_or_create_by(name: "Bodega")
    when "BO"
      p_type = ProjectType.find_or_create_by(name: "Bodega-Oficina")
    when "BLC"
      p_type = ProjectType.find_or_create_by(name: "Bodega, Comercio")
    when "BOLC"
      p_type = ProjectType.find_or_create_by(name: "Bodega, Oficina, Comercio")
    when "C"
      p_type = ProjectType.find_or_create_by(name: "Casas")
    when "CD"
      p_type = ProjectType.find_or_create_by(name: "Casas, Departamento")
    when "CLC"
      p_type = ProjectType.find_or_create_by(name: "Vivienda, Local Comercial")
    when "D"
      p_type = ProjectType.find_or_create_by(name: "Departamentos")
    when "DC"
      p_type = ProjectType.find_or_create_by(name: "Departamento, Vivienda")
    when "DLC"
      p_type = ProjectType.find_or_create_by(name: "Departamento, Local Comercial")
    when "DLCO"
      p_type = ProjectType.find_or_create_by(name: "Departamento, Local Comercial y  Oficina")
    when "DO"
      p_type = ProjectType.find_or_create_by(name: "Departamento y Oficinas")
    when "DOLC"
      p_type = ProjectType.find_or_create_by(name: "Departamento, Oficina y Local Comercial")
    when "DLCEQ"
      p_type = ProjectType.find_or_create_by(name: "Departamento, Local Comercial y Equipamiento")
    when "EQ"
      p_type = ProjectType.find_or_create_by(name: "Equipamiento")
    when "EQLC"
      p_type = ProjectType.find_or_create_by(name: "Equipamiento y Local Comercial")
    when "EQO"
      p_type = ProjectType.find_or_create_by(name: "Equipamiento y Oficina")
    when "H"
      p_type = ProjectType.find_or_create_by(name: "Hotel")
    when "HLC"
      p_type = ProjectType.find_or_create_by(name: "Hotel y Local Comercial")
    when "HO"
      p_type = ProjectType.find_or_create_by(name: "Hotel, Oficina")
    when "HR"
      p_type = ProjectType.find_or_create_by(name: "Hotel & Restaurante")
    when "IN"
      p_type = ProjectType.find_or_create_by(name: "Industria")
    when "LC"
      p_type = ProjectType.find_or_create_by(name: "Local Comercial")
    when "LCEQ"
      p_type = ProjectType.find_or_create_by(name: "Local Comercial y Equipamiento")
    when "LCH"
      p_type = ProjectType.find_or_create_by(name: "Local Comercial y Hotel")
    when "LCO"
      p_type = ProjectType.find_or_create_by(name: "Local Comercial y Oficina")
    when "O"
      p_type = ProjectType.find_or_create_by(name: "Oficinas")
    when "OB"
      p_type = ProjectType.find_or_create_by(name: "Oficinas y Bodega")
    when "OLC"
      p_type = ProjectType.find_or_create_by(name: "Oficina y Local Comercial")
    when "OLCB"
      p_type = ProjectType.find_or_create_by(name: "Oficina y Local Comercial")
    when "OEQ"
      p_type = ProjectType.find_or_create_by(name: "Oficina y Equipamiento")
    when "VC"
      p_type = ProjectType.find_or_create_by(name: "Vivienda-Comercio")
    when "VO"
      p_type = ProjectType.find_or_create_by(name: "Vivienda-Oficina")
    end
    puts "estamos en project  types"
    @p_type = p_type
  end

end
