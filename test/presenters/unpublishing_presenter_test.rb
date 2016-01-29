require 'test_helper'

class UnpublishingPresenterTest < ActiveSupport::TestCase
  test 'presents the basic details required to display an unpublishing' do
    assert_equal unpublishing['format'], presented_unpublishing.format
    assert_equal unpublishing['locale'], presented_unpublishing.locale
    assert_equal unpublishing['details']['explanation'], presented_unpublishing.explanation
    assert_equal unpublishing['details']['alternative_url'], presented_unpublishing.alternative_url
  end

  def unpublishing
    govuk_content_schema_example('unpublishing', 'unpublishing')
  end

  def presented_unpublishing
    UnpublishingPresenter.new(unpublishing)
  end
end
