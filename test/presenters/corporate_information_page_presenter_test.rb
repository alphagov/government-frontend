require 'presenter_test_helper'

class CorporateInformationPagePresenterTest
  class PresentedCorporateInformationPage < PresenterTestCase
    def format_name
      "corporate_information_page"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end
  end
end
