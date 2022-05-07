module FlexOrdersHelper
  def flex_orders_plans
    FlexOrder::PLANS.invert.reverse_each.to_json
  end
end
