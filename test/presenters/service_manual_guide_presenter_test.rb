require 'test_helper'

class ServiceManualGuidePresenterTest < ActiveSupport::TestCase
  test 'presents the basic details required to display a Service Manual Guide' do
    assert_equal "Agile", presented_guide.title
    assert_equal "service_manual_guide", presented_guide.format
    assert presented_guide.body.size > 10
    assert presented_guide.header_links.size >= 1

    content_owner = presented_guide.content_owner
    assert content_owner.title.present?
    assert content_owner.href.present?

    related_discussion = presented_guide.related_discussion
    assert related_discussion.title.present?
    assert related_discussion.href.present?
  end

  test '#last_updated_ago_in_words outputs a human readable definition of time ago' do
    guide = presented_guide('public_updated_at' => 1.year.ago.iso8601)
    assert_equal 'about 1 year ago', guide.last_updated_ago_in_words
  end

  test '#last_update_timestamp outputs a nicely formatted timestamp' do
    guide = presented_guide('public_updated_at' => '2014-10-26T10:27:34Z')
    assert_equal '26 October 2014 10:27', guide.last_update_timestamp
  end

private

  def presented_guide(overriden_attributes = {})
    ServiceManualGuidePresenter.new(
      JSON.parse(GovukContentSchemaTestHelpers::Examples.new.get('service_manual_guide', 'basic_with_related_discussions')).merge(overriden_attributes)
    )
  end
end
