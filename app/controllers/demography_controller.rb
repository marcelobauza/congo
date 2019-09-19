class DemographyController < ApplicationController
  def dashboards
    respond_to do |f|
      f.js
    end
  end

  def general

    result=[]
    data =[]
    people_by_home = Censu.average_people_by_home(params)
    homes_total = (people_by_home.nil? or people_by_home[:homes_total].nil?)? 0.0 : people_by_home[:homes_total]
    people_total = (people_by_home.nil? or people_by_home[:people_total].nil?)? 0.0 : people_by_home[:people_total]
    homes_avg = (people_by_home.nil? or people_by_home[:homes_avg].nil?)? 0.0 : people_by_home[:homes_avg]
    people_avg = (people_by_home.nil? or people_by_home[:people_avg].nil?)? 0.0 : people_by_home[:people_avg]

    data = [
      {:name => t(:HOMES_TOTAL), :count => NumberFormatter.format(homes_total, false)},
      {:name => t(:PEOPLE_TOTAL), :count => NumberFormatter.format(people_total, false)},
      {:name => t(:HOMES_AVG), :count => NumberFormatter.format(homes_avg, true)},
      {:name => t(:PEOPLE_AVG), :count => NumberFormatter.format(people_avg, true)},
    ]
    result.push({"title":"Información general","data": data} )


    data =[]
    @census_sources = CensusSource.all
    data.push("census_sources": @census_sources)
    @categories = Category.all.order(:position)
    data.push("categories": @categories)
    result.push({"title":"Fuente de datos", "data":data}) 

    render json: result
  end



end
