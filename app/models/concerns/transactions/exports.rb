module Transactions::Exports
  extend ActiveSupport::Concern

  module ClassMethods
    def get_csv_data_sii(filters)
      cond = "transactions.inscription_date BETWEEN '#{filters[:date_from]}' "
      cond += "AND '#{filters[:date_to]}' "

      if !filters['polygon_id'].empty?
        session_saved = ApplicationStatus.find(filters[:polygon_id])
        if !session_saved[:filters]['wkt'].nil?
          cond += " AND " + WhereBuilder.build_within_condition(session_saved[:filters]['wkt'])
        elsif !session_saved[:filters]['centerpt'].nil?
          cond += " AND " +  WhereBuilder.build_within_condition_radius(session_saved[:filters]['centerpt'], session_saved[:filters]['radius'] )
        else

          cond += " AND county_id in (#{session_saved[:filters]['county_id'].join(",")}) " if !session_saved[:filters]['county_id'].blank?
        end
      else
        counties = filters[:county_id].reject!(&:blank?)
        cond += " AND county_id in (#{counties.join(",")}) " if !filters[:county_id].blank?
      end

      cond += " AND property_type_id = #{filters[:property_type_id]}" if !filters[:property_type_id].blank?

      transactions = Transaction.includes(:seller_type, :surveyor, :user, :county, :property_type).
        where(cond).
        order("transactions.inscription_date")

      return CsvParser.get_transactions_csv_data_sii(transactions)
    end
  end
end


