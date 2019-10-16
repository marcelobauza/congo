class FutureProjectsController < ApplicationController
  before_action :set_future_project, only: [:show, :edit, :update, :destroy]
  
  def index
    @data = FutureProject.where(id: params[:id]).first

    respond_to do |f|
      f.json
    end
    
  end


  def graduated_points
    @interval = FutureProject.interval_graduated_points(params)
    render json: {data: @interval}
  end

  def dashboards
    respond_to do |f|
      f.js
    end
  end

  def future_projects_summary
    session[:data] = params
    params[:user_id] = current_user.id
    @result = FutureProject.summary(params)
    return @result
  end
  def period
    @period = FutureProject.get_last_period
    @first_period = FutureProject.get_first_bimester_with_future_projects

    unless @period.nil?
      unless FutureProject.is_periods_distance_allowed?(@first_period , @period.first, @period.size)
        @first_period[:year] = @period.last[:year]
        @first_period[:period] = @period.last[:period]
      end
    end
    render json: {data: @period}
  end
end
