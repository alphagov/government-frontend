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

    assert_equal 2, topic.link_groups.size
    assert_equal ["Agile and government services", "Agile methods"], topic.link_groups.map(&:title)
    assert_equal [true, true], topic.link_groups.map{ |lg| lg.description.present? }
  end

  test 'loads linked items within link groups and populates them with data from "links" based on content_id' do
    groups = presented_topic.link_groups
    assert_equal [2, 2], groups.map(&:linked_items).map(&:size)

    agile_and_services_items = groups.find{ |li| li.title == "Agile and government services" }.linked_items
    assert_equal ["Agile and government services: an introduction", "Agile methodology explained"], agile_and_services_items.map(&:label)
    assert_equal ["/service-manual/agile-delivery/agile-and-government-services", "/service-manual/agile-delivery/agile-methodology-explained"], agile_and_services_items.map(&:href)
  end

  test 'does not fail if there are no linked_groups' do
    topic = presented_topic(details: { link_groups: nil })

    assert_equal [], topic.link_groups
  end

private

  def presented_topic(overriden_attributes = {})
    parsed = JSON.parse(GovukContentSchemaTestHelpers::Examples.new.get('topic', 'service_manual_topic'))
    ServiceManualTopicPresenter.new(
      parsed.deep_merge!(overriden_attributes.with_indifferent_access)
    )
  end
end

