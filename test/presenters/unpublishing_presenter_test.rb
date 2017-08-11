require 'test_helper'

class UnpublishingPresenterTest < ActiveSupport::TestCase
  test 'presents the basic details required to display an unpublishing' do
    assert_equal unpublishing['schema_name'], presented_unpublishing.schema_name
    assert_equal unpublishing['locale'], presented_unpublishing.locale
    assert_equal unpublishing['details']['explanation'], presented_unpublishing.explanation

    assert_nil unpublishing['details']['alternative_url']
    assert_nil presented_unpublishing.alternative_url
  end

  def unpublishing
    govuk_content_schema_example('unpublishing', 'unpublishing')
  end

  def presented_unpublishing
    UnpublishingPresenter.new(unpublishing)
  end
end
