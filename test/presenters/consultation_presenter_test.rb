require 'presenter_test_helper'

class ConsultationPresenterTest
  class PresentedConsultation < PresenterTestCase
    def format_name
      " consultation "
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end
  end
end
