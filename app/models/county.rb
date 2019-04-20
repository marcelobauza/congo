class County < ApplicationRecord

  has_and_belongs_to_many :users
  has_and_belongs_to_many :roles

  #has_many :future_projects, :dependent => :nullify
  #has_many :projects, :dependent => :nullify
  has_many :transactions, :dependent => :nullify
 # has_many :building_regulations, :dependent => :nullify
 # has_many :commercial_cellars, :dependent => :nullify
 # has_many :county_ufs
 # has_many :order_details
 # has_many :user_expirations

#  has_attached_file :zip_file, :path => ":rails_root/db/data/pdf/:basename.:extension"

  #named_scope :all_without_geom, :select => "id, name, code, zip_file_file_name, code_sii"

  def self.find_by_lon_lat(lon, lat)
    County.find_by_x_y(lon, lat, 4326)
  end

  def self.find_by_x_y(x, y, srid)
    County.where("ST_Contains(the_geom, ST_SetSRID(ST_MakePoint(#{x},#{y}),#{srid}))").first
  end

  def self.get_orders_counties
    County.select("id, rate, name").where("rate is not null").order("name")
  end

  def self.get_county_by_polygon_intersection(wkt)
    County.select("id").where(WhereBuilder.build_intersects_condition(wkt))
  end

  def self.sorted_by_name
    self.order(:name)
  end
end
