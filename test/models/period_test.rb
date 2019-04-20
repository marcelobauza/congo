require 'test_helper'

class PeriodTest < ActiveSupport::TestCase
   test "the truth" do
     assert true
   end

    test "get periods" do
    
      @a = Period.get_periods(2, 2019, 6, 1 )
      return @a 
    end 
end
