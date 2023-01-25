require "test_helper"

class ServiceManualTopicTest < ActionDispatch::IntegrationTest
  def topic_example
    @topic_example ||= govuk_content_schema_example("service_manual_topic", "service_manual_topic")
  end

  test "it uses topic description as meta description" do
    stub_content_store_has_item("/service-manual/test-topic", topic_example.to_json)

    visit "/service-manual/test-topic"

    assert page.has_css?('meta[name="description"]', visible: false)
    tag = page.find 'meta[name="description"]', visible: false
    assert_equal topic_example["description"], tag["content"]
  end

  test "it doesn't write a meta description if there is none" do
    topic_example[:description] = ""
    stub_content_store_has_item("/service-manual/test-topic-no-description", topic_example.to_json)

    visit "/service-manual/test-topic-no-description"

    assert_not page.has_css?('meta[name="description"]', visible: false)
  end

  test "it lists communities in the sidebar" do
    setup_and_visit_content_item("service_manual_topic")

    within(".related-communities") do
      assert page.has_link?(
        "Agile delivery community",
        href: "/service-manual/communities/agile-delivery-community",
      )
      assert page.has_link?(
        "User research community",
        href: "/service-manual/communities/user-research-community",
      )
    end
  end

  test "it doesn't display content in accordian if not eligible" do
    setup_and_visit_content_item("service_manual_topic")

    assert_not page.has_css?(".gem-c-accordion")
  end

  test "it displays content using an accordian if eligible" do
    content_item = govuk_content_schema_example("service_manual_topic", "service_manual_topic")
    third_linked_item = { content_id: SecureRandom.uuid, title: "linky", base_path: "/basey" }
    third_group = { name: "Group 3", description: "The third group", content_ids: [third_linked_item[:content_id]] }

    content_item["links"]["linked_items"] << third_linked_item
    content_item["details"]["groups"] << third_group
    content_item["details"]["visually_collapsed"] = true

    stub_content_store_has_item(content_item["base_path"], content_item)
    visit content_item["base_path"]

    assert page.has_css?(".gem-c-accordion")
  end

  test "it includes a link to subscribe for email alerts" do
    setup_and_visit_content_item("service_manual_topic")

    assert page.has_link?(
      "email",
      href: "/email-signup?link=/service-manual/test-expanded-topic",
    )
  end
end
