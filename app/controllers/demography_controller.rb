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
      {:label => t(:HOMES_TOTAL), :value => NumberFormatter.format(homes_total, false)},
      {:label => t(:PEOPLE_TOTAL), :value => NumberFormatter.format(people_total, false)},
      {:label => t(:HOMES_AVG), :value => NumberFormatter.format(homes_avg, true)},
      {:label => t(:PEOPLE_AVG), :value => NumberFormatter.format(people_avg, true)},
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
