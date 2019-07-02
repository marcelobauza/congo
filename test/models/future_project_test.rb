require 'test_helper'

class FutureProjectTest < ActiveSupport::TestCase
   def test_the_truth 
      assert true
    end
   def test_summary
    filters = {"to_year":2019, "to_period":6, "county_id":"17"}
    @summary = FutureProject.summary(filters)
    assert_not_nil(@summary, "algo mal")
    end
end
