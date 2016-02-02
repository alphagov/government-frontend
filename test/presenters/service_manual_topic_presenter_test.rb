require 'test_helper'

class ServiceManualTopicPresenterTest < ActiveSupport::TestCase
  test 'presents the basic details required to display a Service Manual Topic' do
    topic = presented_topic(title: "Agile", description: "Agile Test Description")
    assert_equal "Agile", topic.title
    assert_equal "Agile Test Description", topic.description
    assert topic.format.present?
    assert topic.locale.present?
  end

  test 'loads link groups' do
    topic = presented_topic

    assert_equal 2, topic.groups.size
    assert_equal ["Group 1", "Group 2"], topic.groups.map(&:name)
    assert_equal [true, true], topic.groups.map{ |lg| lg.description.present? }
  end

  test 'loads linked items within link groups and populates them with data from "links" based on content_id' do
    groups = presented_topic.groups
    assert_equal [2, 1], groups.map(&:linked_items).map(&:size)

    group_items = groups.find { |li| li.name == "Group 1" }.linked_items
    assert_equal ["Accessibility", "Addresses"], group_items.map(&:label)
    assert_equal ["/service-manual/user-centred-design/accessibility", "/service-manual/user-centred-design/resources/patterns/addresses"], group_items.map(&:href)
  end

  test 'does not fail if there are no linked_groups' do
    topic = presented_topic(details: { groups: nil })

    assert_equal [], topic.groups
  end

  test 'omits groups that have no published linked items' do
    topic = presented_topic(links: { linked_items: [] }) # unpublished content_ids are filtered out from content-store responses
    assert_equal 0, topic.groups.size
  end

private

  def presented_topic(overriden_attributes = {})
    parsed = JSON.parse(GovukContentSchemaTestHelpers::Examples.new.get('topic', 'service_manual_topic'))
    ServiceManualTopicPresenter.new(
      parsed.deep_merge!(overriden_attributes.with_indifferent_access)
    )
  end
end

