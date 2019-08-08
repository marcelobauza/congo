class ProjectInstance < ApplicationRecord
  belongs_to :project
  belongs_to :project_status
  has_many :project_instance_mixes, :dependent => :destroy

  #validate :date_format

  #before_save :get_bimester_year

  #validates_presence_of :total_units
  #validates_presence_of :stock_units
  #validates_presence_of :sold_units
  #validates_presence_of :sale_month
  #validates_presence_of :project_id
  #validates_presence_of :uf_m2
  #validates_presence_of :uf_value
  #validates_presence_of :selling_speed
  #validates_presence_of :percentage_sold
  #validates_presence_of :project_status_id
  #validates_presence_of :sale_date


=begin
  validates_numericality_of :usable_square_meters, :unless => 'usable_square_meters.blank?'
  validates_numericality_of :terrace_square_meters, :unless => 'terrace_square_meters.blank?'
  validates_numericality_of :uf_m2, :unless => 'uf_m2.blank?'
  validates_numericality_of :uf_value, :unless => 'uf_value.blank?'
  validates_numericality_of :selling_speed, :unless => 'selling_speed.blank?'
  validates_numericality_of :percentage_sold, :unless => 'percentage_sold.blank?'
  validates_numericality_of :m2_field, :unless => 'm2_field.blank?'
  validates_numericality_of :m2_built, :unless => 'm2_built.blank?'

  validates_numericality_of :total_units, :only_integer => true, :unless => 'total_units.blank?'
  validates_numericality_of :stock_units, :only_integer => true, :unless => 'stock_units.blank?'
  validates_numericality_of :sold_units, :only_integer => true, :unless => 'sold_units.blank?'
  validates_numericality_of :sale_month, :only_integer => true, :unless => 'sale_month.blank?'
=end

  # validates_numericality_of :bimester, :less_than_or_equal_to => 6, :only_integer => true
  # validates_numericality_of :year, :only_integer => true, :unless => 'year.blank?'

#  delegate :name, :to => :project_status, :prefix => true, :allow_nil => true
  delegate :name, :to => :project, :prefix => true, :allow_nil => true
  delegate :address, :to => :project, :prefix => true, :allow_nil => true
  delegate :county_name, :to => :project, :prefix => true, :allow_nil => true
  delegate :agency_name, :to => :project, :prefix => true, :allow_nil => true

  def save_instance_data_fulcrum(project_id, project_status_id, bimester, year, cadastre, comments )
 
  self.project_id = project_id
  self.project_status_id = project_status_id
  self.bimester = bimester
  self.year = year
  self.cadastre = cadastre.strftime("%d/%m/%y") 

  self.comments= comments

    return self.save
  
  end

def save_instance_data(data, mixes, t_units, st_units, sld_units, project_type)
     ic = Iconv.new('UTF-8', 'ISO-8859-1')
     status = ProjectStatus.find_or_create_by(name: data["ESTADO"])
     self.project_status_id = status.id
     self.cadastre = data['CATASTRO']
     self.year = data["YEAR"].to_i
     self.bimester = data["BIMESTRE"].to_i

     if project_type == "Casas"
      # self.m2_field = data["M2_TERRENO"].to_f unless data["M2_TERRENO"].to_i == -1
      # self.m2_built = data["M2_CONST"].to_f unless data["M2_CONST"].to_i == -1

       case data["TIPO_C"].to_s
       when "A"
         self.home_type = "Aislada"
       when "P"
         self.home_type = "Pareada"
       when "T"
         self.home_type = "Tren"
       when "A-P"
         self.home_type = "Aislada-Pareada"
       end
     else
       self.usable_square_meters = data["M2_UTILES"] unless data["M2_UTILES"] == -1
       self.terrace_square_meters = data["M2_TERRAZA"] unless data["M2_TERRAZA"] == -1
     end

     self.comments = data["COMMENTS"]
     ProjectInstanceMix.associate_instance_mix_data(mixes, self, t_units)
     return self.save
   end

  def self.find_offer_mix(instance_id)
    joins = "INNER JOIN project_mixes on project_mixes.id = project_instance_mixes.mix_id"
    ProjectInstance.joins(:project_instance_mixes, joins).
      where(id: instance_id).
      group(" project_mixes.mix_type").
      pluck("sum(project_instance_mixes.total_units), project_mixes.mix_type")
  end

  def self.find_sale_mix(instance_id)
    joins = "INNER JOIN project_mixes on project_mixes.id = project_instance_mixes.mix_id"
    ProjectInstance.joins(:project_instance_mixes, joins).
      where(id: instance_id).
      group(" project_mixes.mix_type").
      pluck("sum(project_instance_mixes.total_units - project_instance_mixes.stock_units), project_mixes.mix_type")
  end

end

