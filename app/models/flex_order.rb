class FlexOrder < ApplicationRecord
  include FlexOrders::Plans

  belongs_to :user
end
