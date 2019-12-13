class DemographyController < ApplicationController
  def dashboards
    respond_to do |f|
      f.js
    end
  end

  def general
    params[:user_id] = current_user.id
    @result = Censu.summary(params)
    render json: @result
  end
end
