class ProjectInstanceMix < ApplicationRecord
  belongs_to :project_instance
  belongs_to :project_mix, :foreign_key => :mix_id
  has_one :project_instance_mix_view

  has_many :trends

  attr_accessor :get_bedroom, :get_bathroom

  def self.associate_instance_mix_data(mixes, project_instance)
    ProjectInstanceMix.where(project_instance_id: project_instance).delete_all

    mixes.each do |mix|
      project_instance.project_instance_mixes << mix
    end
  end

  def self.get_mix_by_project_instance_id(instance_id)
    mixes = ProjectInstanceMix.find(:all, :conditions => "project_instance_id = #{instance_id.to_s}")
    mix_description = ""

    mixes.each do |mx|
      mix = ProjectMix.find(mx.mix_id)
      mix_description += mix.mix_type + " " + mx.percentage.to_s + "% - "
    end

    mix_description.chomp!(" - ")
  end

  def project_mix_type
    self.project_mix.try(:mix_type)
  end

  def get_sold_units
    total_units - stock_units if !total_units.nil? && !stock_units.nil?
  end

  def get_bedroom
    project_mix.bedroom if !project_mix.nil?
  end

  def get_bathroom
    project_mix.bathroom if !project_mix.nil?
  end

  def uf_avg_percent

    #perc = self.percentage.nil? ? 0 : self.percentage
    desc = 1 - (self.percentage || 0) / 100
    ((self.uf_min || 0) * desc + (self.uf_max || 0) * desc) / 2
  end

  def uf_m2
    (self.uf_avg_percent || 0) / (self.mix_usable_square_meters + (self.mix_terrace_square_meters || 0) / 2)
  end

  def uf_m2_u
    (self.uf_avg_percent || 0) / self.mix_usable_square_meters
  end

  def vhmu
    select = "select months(#{self.project_instance_id}) as months"
    result = Util.execute(select)
    months = result[0]['months'].to_f
    vel_vta = (self.total_units - self.stock_units) / months unless months == 0
  end

  def uf_range
    select = "select uf_range(#{self.project_instance_id}, #{self.id}) as uf_range"
    result = Util.execute(select)
    result[0]['uf_range']
  end

  def usable_range
    select = "select usable_range(#{self.project_instance_id}, #{self.id}) as usable_range"
    result = Util.execute(select)
    result[0]['usable_range']
  end
end
