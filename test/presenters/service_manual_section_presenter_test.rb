require 'test_helper'

class ServiceManualSectionPresenterTest < ActiveSupport::TestCase
  test 'presents the basic details required to display a Service Manual Section' do
    section = presented_section(title: "Agile", description: "Agile Test Description")
    assert_equal "Agile", section.title
    assert_equal "Agile Test Description", section.description
    assert section.format.present?
    assert section.locale.present?
  end

  test 'loads link groups' do
    section = presented_section

    assert_equal 2, section.link_groups.size
    assert_equal ["Agile and government services", "Agile methods"], section.link_groups.map(&:title)
    assert_equal [true, true], section.link_groups.map{ |lg| lg.description.present? }
  end

  test 'loads linked items within link groups and populates them with data from "links" based on content_id' do
    groups = presented_section.link_groups
    assert_equal [2, 2], groups.map(&:linked_items).map(&:size)

    agile_and_services_items = groups.find{ |li| li.title == "Agile and government services" }.linked_items
    assert_equal ["Agile and government services: an introduction", "Agile methodology explained"], agile_and_services_items.map(&:label)
    assert_equal ["/service-manual/agile-delivery/agile-and-government-services", "/service-manual/agile-delivery/agile-methodology-explained"], agile_and_services_items.map(&:href)
  end

  test 'does not fail if there are no linked_groups' do
    section = presented_section(details: { link_groups: nil })

    assert_equal [], section.link_groups
  end

private

  def presented_section(overriden_attributes = {})
    parsed = JSON.parse(GovukContentSchemaTestHelpers::Examples.new.get('service_manual_section', 'two_groups_with_one_item_each'))
    ServiceManualSectionPresenter.new(
      parsed.deep_merge!(overriden_attributes.with_indifferent_access)
    )
  end
end

