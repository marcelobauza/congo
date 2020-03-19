class DemographyController < ApplicationController
  def dashboards

    respond_to do |f|
      f.js
    end
  end

  def general
    session[:data] = params
    params[:user_id] = current_user.id
    @result = Censu.summary(params)
    render json: @result
  end

  def calculated_gse
    filters  = JSON.parse(session[:data].to_json, {:symbolize_names=> true})
   @b = Censu.calculated_gse filters
   @sum_expenses = Censu.sum_expenses filters
   @houses = Censu.sum_house filters
   @incomes = Censu.sum_monthly_incomes filters
  end

end
