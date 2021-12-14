class Admin::FlexOrdersController < ApplicationController
  layout 'admin'

  def index
    from = (params[:query] && params[:query][:from].to_date) || Time.now
    to   = (params[:query] && params[:query][:to].to_date) || Time.now

    @flex_orders = FlexOrder.where created_at: from.beginning_of_day..to.end_of_day
  end
end
