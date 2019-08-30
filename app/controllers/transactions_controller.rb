class TransactionsController < ApplicationController
  include NumberFormatter

  def index
    @data = Transaction.where(bimester: params[:bimester], year: params[:year]).where("st_contains(ST_Buffer(ST_GeomFromText('POINT(#{params[:lng]} #{params[:lat]})')::geography,20)::geometry, the_geom) ").first
    respond_to do |f|
      f.json
    end
  end


  def graduated_points
      @interval = Transaction.interval_graduated_points(params)
      render json: {data: @interval}
  end

  def dashboards
    respond_to do |f|
      f.js
    end
  end

  def transactions_summary
    session[:data] = params.clone
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
