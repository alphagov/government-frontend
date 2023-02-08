require "presenter_test_helper"

class ServiceManualTopicPresenterTest < PresenterTestCase
  def schema_name
    "service_manual_topic"
  end

  test "presents the basic details required to display a Service Manual Topic" do
    topic = presented_item(schema_name, "title" => "Agile", "description" => "Agile Test Description")
    assert_equal "Agile", topic.title
    assert_equal "Agile Test Description", topic.description
    assert topic.document_type.present?
    assert topic.locale.present?
  end

  test "loads link groups" do
    topic = presented_item

    assert_equal 2, topic.groups.size
    assert_equal ["Group 1", "Group 2"], topic.groups.map(&:name)
    assert_equal([true, true], topic.groups.map { |lg| lg.description.present? })
  end

  test 'loads linked items within link groups and populates them with data from "links" based on content_id' do
    groups = presented_item.groups
    assert_equal [2, 1], groups.map(&:linked_items).map(&:size)

    group_items = groups.find { |li| li.name == "Group 1" }.linked_items
    assert_equal %w[Accessibility Addresses], group_items.map(&:label)
    assert_equal ["/service-manual/user-centred-design/accessibility", "/service-manual/user-centred-design/resources/patterns/addresses"], group_items.map(&:href)
  end

  test "returns accordion content data" do
    accordion_content = presented_item.accordion_content
    first_accordion_section = {
      data_attributes: {
        ga4: {
          event_name: "select_content",
          type: "accordion",
          text: "Group 1",
          index: 1,
          index_total: 2,
        },
      },
      heading: { text: "Group 1" },
      summary: { text: "The first group" },
      content: { html: "<ul class=\"govuk-list\">\n<li><a class=\"govuk-link\" href=\"/service-manual/user-centred-design/accessibility\">Accessibility</a></li>\n<li><a class=\"govuk-link\" href=\"/service-manual/user-centred-design/resources/patterns/addresses\">Addresses</a></li>\n</ul>" },
      expanded: true,
    }

    assert_equal 2, accordion_content.count
    assert_equal first_accordion_section, accordion_content.first
  end

  test "does not fail if there are no linked_groups" do
    topic = presented_item(schema_name, "details" => { "groups" => nil })

    assert_equal [], topic.groups
  end

  test "omits groups that have no published linked items" do
    topic = presented_item(schema_name, "links" => { "linked_items" => [] }) # unpublished content_ids are filtered out from content-store responses
    assert_equal 0, topic.groups.size
  end

  test "#content_owners loads the data into objects" do
    topic = presented_item(schema_name, "links" => { "content_owners" => [
      { "title" => "Design Community", "base_path" => "/service-manual/design-community" },
      { "title" => "Agile Community", "base_path" => "/service-manual/agile-community" },
    ] })
    assert_equal 2, topic.content_owners.size
    design_community = topic.content_owners.first
    assert_equal "Design Community", design_community.title
    assert_equal "/service-manual/design-community", design_community.href
    agile_community = topic.content_owners.last
    assert_equal "Agile Community", agile_community.title
    assert_equal "/service-manual/agile-community", agile_community.href
  end

  test "#breadcrumbs links to the root path" do
    topic = presented_item

    expected_breadcrumbs = [
      { title: "Service manual", url: "/service-manual" },
    ]
    assert_equal expected_breadcrumbs, topic.breadcrumbs
  end

  test "#email_alert_signup returns a link to the email alert signup" do
    assert_equal "/email-signup?link=/service-manual/test-expanded-topic",
                 presented_item.email_alert_signup_link
  end
end
