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
  #
  validates :project_id, :project_status_id, :bimester, :year, :cadastre, presence: true

#  delegate :name, :to => :project_status, :prefix => true, :allow_nil => true
  delegate :name, :to => :project, :prefix => true, :allow_nil => true
  delegate :address, :to => :project, :prefix => true, :allow_nil => true
  delegate :county_name, :to => :project, :prefix => true, :allow_nil => true
  delegate :agency_name, :to => :project, :prefix => true, :allow_nil => true

def save_instance_data(data, mixes, project_type)
     ic                     = Iconv.new('UTF-8', 'ISO-8859-1')
     status                 = ProjectStatus.find_or_create_by(name: data["ESTADO"])
     self.project_status_id = status.id
     self.cadastre          = data['CATASTRO']
     self.year              = data["YEAR"].to_i
     self.bimester          = data["BIMESTRE"].to_i
     self.comments          = data["COMMENTS"]

     ProjectInstanceMix.associate_instance_mix_data(mixes, self)
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

def get_total_units
    @total = ProjectInstanceMix.where(project_instance_id: self.id).sum(:total_units)
end
def get_total_available
    @total = ProjectInstanceMix.where(project_instance_id: self.id).sum(:stock_units)
end

def get_pp_uf
  select = "select pp_uf(#{self.id}) as pp_uf"
  result = Util.execute(select)
  result[0]['pp_uf'].to_f
end

def get_pp_uf_m2
  select = "select pp_uf_m2(#{id.to_i}) as pp_uf_m2"
  result = Util.execute(select)
  result[0]['pp_uf_m2'].to_f
end

def get_percent_venta
  select = "select percent_venta(#{self.id.to_i}) as percent_venta"
  result = Util.execute(select)
  result[0]['percent_venta'].to_f
end

def get_pp_utiles
  select = "select pp_utiles(#{self.id}) as pp_utiles"
  result = Util.execute(select)
  result[0]['pp_utiles'].to_f
end
def get_pp_utiles_terrace
  select = "select pp_utiles_terrace(#{self.id.to_i}) as pp_utiles_terrace"
      result = Util.execute(select)
        result[0]['pp_utiles_terrace'].to_f
end
def get_pp_terreno
    select = "select pp_terreno(#{id.to_i}) as pp_terreno"
      result = Util.execute(select)
        result[0]['pp_terreno'].to_i
end

def get_sale_months
    select = "select months(#{id.to_i}) as sale_months"
      result = Util.execute(select)
        result[0]['sale_months'].to_i
end
def get_vhmo
    select = "select vhmo(#{id.to_i}) as vhmo"
      result = Util.execute(select)
        result[0]['vhmo'].to_f
end

def get_pp_uf_dis
    select = "select pp_uf_dis(#{id.to_i}) as pp_uf_dis"
      result = Util.execute(select)
        result[0]['pp_uf_dis'].to_f
end
def get_vhmd
    select = "select vhmd(#{id.to_i}) as vhmd"
      result = Util.execute(select)
        result[0]['vhmd'].to_f
end
def get_masd
    select = "select masd(#{id.to_i}) as masd"
      result = Util.execute(select)
        result[0]['masd'].to_f
end

def get_pxq
    select = "select pxq(#{id.to_i}) as pxq"
      result = Util.execute(select)
        result[0]['pxq'].to_f
end

def get_pxq_d
    select = "select pxq_d(#{id.to_i}) as pxq_d"
      result = Util.execute(select)
        result[0]['pxq_d'].to_f
end
end
