class CountiesUser < ApplicationRecord
  belongs_to :county
  belongs_to :user

  def self.enabled_by_user user
    counties = CountiesUser.where(user_id: user)

    factory = RGeo::GeoJSON::EntityFactory.instance
    feature = []
    counties.each do |c|
      county = c.county
      feature << factory.feature(c.county.county_centroid, nil, {name: c.county.name, id: c.county.id})
    end

    output_geojson_collection =  RGeo::GeoJSON.encode factory.feature_collection(feature)
  end
end
