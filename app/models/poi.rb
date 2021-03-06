class Poi < ApplicationRecord
  belongs_to :poi_subcategory

  validates :name, :poi_subcategory_id, :the_geom, presence: true

  def self.get_around_pois(point_id, layer)

    case layer
    when 'future_projects_info'
      model = 'future_projects'
    when 'projects_feature_info'
      model = 'projects'
    when 'transactions_info'
      model = 'transactions'
    end

    if !model.nil?
      select = "round(ST_Distance(the_geom, (SELECT the_geom FROM #{model} WHERE id = #{point_id}), false)) as meters, "
      select += "poi_subcategories.name as sub_category_name, pois.name"
      @pois =     Poi.select(select).joins(:poi_subcategory).order("meters").limit(200)
    end
  end
end
