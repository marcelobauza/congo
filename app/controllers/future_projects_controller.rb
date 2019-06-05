class FutureProjectsController < ApplicationController
  before_action :set_future_project, only: [:show, :edit, :update, :destroy]

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

    #file_path = Xls.generate [result], "/xls", {:file_name => "#{Time.now.strftime("%Y-%m-%d_%H.%M")}_expedientes", :clean_directory_path => true}
    #send_file file_path, :type => "application/excel"
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
