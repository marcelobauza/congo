class ReportsController < ApplicationController
  def future_projects_data

    filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
    @xl = FutureProject.reports(filters)
    respond_to do |format|
      format.xlsx 
    end
  end

  def future_projects_summary
  end


end
