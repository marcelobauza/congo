class CreateNeighborhoodFutureProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :neighborhood_future_projects do |t|
      t.references :neighborhood
      t.integer :year
      t.integer :bimester
      t.integer :total_households
    end

    Neighborhood.all.each do |neighborhood|
      total_house = 0
      (2017..Date.today.year).each do |year|
        (1..6).each do |bimester|
          rfp =  RentFutureProject.where(bimester: bimester, year: year).where("ST_CONTAINS(
            ST_GEOMFROMTEXT('#{neighborhood.the_geom}', 4326), ST_SETSRID(the_geom, 4326))").take

          total_house +=  rfp.total_units if rfp

          nn = NeighborhoodFutureProject.create!(
            neighborhood_id: neighborhood.id,
            year:              year,
            bimester:          bimester,
            total_households:  total_house
          )
        end
      end
    end
  end
end
