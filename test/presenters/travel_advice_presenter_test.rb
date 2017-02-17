require 'presenter_test_helper'

class TravelAdvicePresenterTest
  class PresentedTravelAdvice < PresenterTestCase
    def format_name
      "travel_advice"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end
  end
end
