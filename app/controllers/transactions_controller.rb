class TransactionsController < ApplicationController
  include NumberFormatter

  def index
    @data = Transaction.popup(params)
    respond_to do |f|
      f.json
    end
  end


  def graduated_points
      @interval = Transaction.interval_graduated_points(params)
      render json: {data: @interval}
  end

  def dashboards
    acc     = User.accumulated_download_by_company current_user.id, 'transactions'
    surplus = 0

    total_downloads = current_user.company.transactions_downloads

    @tag = acc > total_downloads ? 'danger' : 'success'
    respond_to do |f|
      f.js
    end
  end

  def transactions_summary
    session[:data] = params.clone
    params[:user_id] = current_user.id
    save_polygon = UserPolygon.save_polygons_for_user params
    @result = Transaction.summary(params)
   return @result
  end

  def period

    @period = Transaction.get_last_period
    @first_period = Transaction.get_first_period_with_transactions

    unless Transaction.is_periods_distance_allowed?(@first_period, @period.first, @period.size)
      @first_period[:year] = @period.last[:year] unless @period.nil?
      @first_period[:period] = @period.last[:period] unless @period.nil?
    end
    render json: {data: @period}
  end
end
