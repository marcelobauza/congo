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
    acc     = User.accumulated_download_by_company current_user.id, 'future_projects'
    surplus = 0

    total_downloads = current_user.company.future_projects_downloads

    @tag = acc > total_downloads ? 'danger' : 'success'
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
