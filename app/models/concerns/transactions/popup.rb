module Transactions::Popup
  extend ActiveSupport::Concern

  module ClassMethods
    def popup params
      @row = Transaction.where(id: params[:id]).first
      @data = Transaction.where("st_Dwithin(st_geomfromtext('#{@row.the_geom}',4326), the_geom, 15, false)").where(WhereBuilder.build_range_periods_by_bimester_transaction_popup(params[:bimester], params[:year], 6))
    end
  end
end
