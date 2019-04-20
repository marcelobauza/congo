module Ranges
  extend ActiveSupport::Concern

  def self.get_ranges

    ranges_result = []

    sub_range_1 = {"min" => 0, "max" => 440}
    sub_range_2 = {"min" => 441, "max" => 929}
    sub_range_3 = {"min" => 930, "max" => 1549}
    sub_range_4 = {"min" => 1550, "max" => 3399}
    sub_range_5 = {"min" => 3400, "max" => 5390}
    sub_range_6 = {"min" => 5391, "max" => 7950}
    sub_range_7 = {"min" => 7951, "max" => 11500}
    sub_range_8 = {"min" => 11501, "max" => 15600}
    sub_range_9 = {"min" => 15601, "max" => 500000}

    ranges_result << sub_range_1 << sub_range_2 << sub_range_3 << sub_range_4 << sub_range_5 << sub_range_6 << sub_range_7 << sub_range_8 << sub_range_9


  end
end
