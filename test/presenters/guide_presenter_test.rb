require 'presenter_test_helper'

class GuidePresenterTest
  class PresentedGuide < PresenterTestCase
    def format_name
      "guide"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end
  end
end
