class Admin::FlexOrdersController < ApplicationController
  layout 'admin'

  def index
    date = params[:query][:date].present? ? params[:query][:date].to_date : Time.now

    @flex_orders = FlexOrder.where created_at: date.beginning_of_day..date.end_of_day
  end
end
