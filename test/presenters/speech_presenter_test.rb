require 'presenter_test_helper'

class SpeechPresenterTest
  class PresentedSpeech < PresenterTestCase
    def format_name
      "speech"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end
  end
end
