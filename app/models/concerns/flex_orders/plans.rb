module FlexOrders::Plans
  extend ActiveSupport::Concern

  included do
    PLANS = plans
  end

  def get_price_by_plans
    sort_plans&.first
  end

  def sort_plans
    PLANS.invert.reverse_each.to_h.detect { |id, plan| amount >= plan }
  end

  module ClassMethods
    def plans
      {
        0 => 9990,
        10 => 8990,
        30 => 7990
      }
    end
  end
end
