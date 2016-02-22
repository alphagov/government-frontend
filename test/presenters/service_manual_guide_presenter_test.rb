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

  test 'breadcrumbs have a root and a topic link' do
    presented_guide = presented_guide("links" => { "topics" => [{ "title" => "Topic", "base_path" => "/service-manual/topic" }] })
    assert_equal [
                   { title: "Service manual", url: "/service-manual" },
                   { title: "Topic", url: "/service-manual/topic" },
                   { title: "Agile" },
                 ],
                 presented_guide.breadcrumbs
  end

  test "breadcrumbs gracefully omit topic if it's not present" do
    presented_guide = presented_guide("links" => {})
    assert_equal [
                   { title: "Service manual", url: "/service-manual" },
                   { title: "Agile" },
                 ],
                 presented_guide.breadcrumbs
  end

  test "#main_topic_title is the title of the main topic" do
    guide = presented_guide("links" => { "topics" => [{ "title" => "Agile Delivery", "base_path" => "/service-manual/topic" }] })
    assert_equal 'Agile Delivery', guide.main_topic_title
  end

  test "#main_topic_title can be empty" do
    guide = presented_guide
    assert_nil guide.main_topic_title
  end

  test '#content_owner fetches the first content owner info from the links' do
    guide = presented_guide(
      'details' => { 'content_owner' => nil },
      'links' => { 'content_owners' => [{ 'title' => 'Design Community', 'base_path' => '/example/dc' }] }
    )
    assert_equal 'Design Community', guide.content_owner.title
    assert_equal '/example/dc', guide.content_owner.href
  end

  test '#content_owner falls back to using deprecated content owner info in details' do
    guide = presented_guide(
      'details' => { 'content_owner' => { 'title' => 'Agile Community', 'href' => 'http://example.com/ac' } },
      'links' => { 'content_owners' => [] }
    )
    assert_equal 'Agile Community', guide.content_owner.title
    assert_equal 'http://example.com/ac', guide.content_owner.href
  end

private

  def presented_guide(overriden_attributes = {})
    ServiceManualGuidePresenter.new(
      JSON.parse(GovukContentSchemaTestHelpers::Examples.new.get('service_manual_guide', 'basic_with_related_discussions')).merge(overriden_attributes)
    )
  end
end
