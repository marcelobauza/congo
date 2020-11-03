module Transactions::Periods
  extend ActiveSupport::Concern

  module ClassMethods
    def get_last_period filters
      if !filters[:county_id].nil?
        conditions = WhereBuilder.build_in_condition("county_id",filters[:county_id])
      elsif !filters[:wkt].nil?
        conditions = WhereBuilder.build_within_condition(filters[:wkt])
      else
        conditions = WhereBuilder.build_within_condition_radius(filters[:centerpt], filters[:radius] )
      end

      last_period_active = Period.where(active: true).order(year: :desc, bimester: :desc).first
      period             = Transaction.select(:year, :bimester).
                             where(active: 'true').
                             where(conditions).
                             where('year <= ? and bimester <= ?', last_period_active.year, last_period_active.bimester).
                             order(year: :desc, bimester: :desc).first
    end

    def get_first_period_with_transactions

      period = Transaction.select(:year, :bimester).group(:year, :bimester).order(:year, :bimester).first

      return nil if period.nil?
      return {:period => period.bimester, :year => period.year}
    end
  end
end
