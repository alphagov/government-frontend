require 'presenter_test_helper'

class HelpPagePresenterTest
  class PresentedHelpPage < PresenterTestCase
    def format_name
      "help_page"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end
  end
end
