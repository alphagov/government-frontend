require 'presenter_test_helper'

class StatisticalDataSetPresenterTest
  class PresentedStatisticalDataSet < PresenterTestCase
    def format_name
      " statistical_data_set "
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end
  end
end
