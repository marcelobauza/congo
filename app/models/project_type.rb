class ProjectType < ApplicationRecord
 has_many :projects
 has_many :future_projects

  DEPARTMENTS = "Departamentos"
  HOUSES = "Casas"
  
  def self.get_project_type_by_first_letter(projtype)
    case projtype
    when "D"
      p_type = ProjectType.find_by(name: "Departamentos")
    when "C"
      p_type = ProjectType.find_by(name: "Casas")
    when "O"
      p_type = ProjectType.find_or_create_by(name: "Oficinas")
    when "LC"
      p_type = ProjectType.find_or_create_by(name: "Local Comercial")
    when "OLC"
      p_type = ProjectType.find_or_create_by(name: "Oficina y Local Comercial")
    when "EQ"
      p_type = ProjectType.find_or_create_by(name: "Equipamiento")
    when "DLC"
      p_type = ProjectType.find_or_create_by(name: "Departamento y Local Comercial") 
    when "DO"
      p_type = ProjectType.find_or_create_by(name: "Departamento y Oficinas")
    when "IN"
      p_type = ProjectType.find_or_create_by(name: "Industria") 
    when "DOLC"
      p_type = ProjectType.find_or_create_by(name: "Departamento, Oficina y Local Comercial")
    when "B"
      p_type = ProjectType.find_or_create_by(name: "Bodega")
    when "BO"
      p_type = ProjectType.find_or_create_by(name: "Bodega-Oficina")
    when "VC"
      p_type = ProjectType.find_or_create_by(name: "Vivienda-Comercio")
    when "VO"
      p_type = ProjectType.find_or_create_by(name: "Vivienda-Oficina")
    when "BLC"
      p_type = ProjectType.find_or_create_by(name: "Bodega, Comercio")
    when "BOLC"
      p_type = ProjectType.find_or_create_by(name: "Bodega, Oficina, Comercio")
    when "HR"
      p_type = ProjectType.find_or_create_by(name: "Hotel & Restaurante")
    when "DC"
      p_type = ProjectType.find_or_create_by(name: "Departamento, Vivienda")
    when "HO"
      p_type = ProjectType.find_or_create_by(name: "Hotel, Oficina")  
    end
    puts "estamos en project  types"
    @p_type = p_type
  end

end
