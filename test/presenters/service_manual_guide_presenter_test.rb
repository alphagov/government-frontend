require "presenter_test_helper"

class ServiceManualGuidePresenterTest < PresenterTestCase
  def schema_name
    "service_manual_guide"
  end

  test "presents the basic details required to display a Service Manual Guide" do
    assert_equal "Agile Delivery", presented_item.title
    assert_equal "service_manual_guide", presented_item.document_type
    assert presented_item.body.size > 10
    assert presented_item.header_links.size >= 1

    content_owner = presented_item.content_owners.first
    assert content_owner.title.present?
    assert content_owner.href.present?
  end

  test "breadcrumbs have a root and a topic link" do
    guide = presented_item
    assert_equal [
      { title: "Service manual", url: "/service-manual" },
      { title: "Agile", url: "/service-manual/agile" },
    ],
                 guide.breadcrumbs
  end

  test "breadcrumbs gracefully omit topic if it's not present" do
    presented_item = presented_item(schema_name, "links" => {})
    assert_equal [
      { title: "Service manual", url: "/service-manual" },
    ],
                 presented_item.breadcrumbs
  end

  test "#category_title is the title of the category" do
    guide = presented_item
    assert_equal "Agile", guide.category_title
  end

  test "#category_title is the title of the parent for a point" do
    content_item = GovukSchemas::Example.find("service_manual_guide", example_name: "point_page")

    presenter = present_example(content_item)

    assert presenter.category_title, "The Service Standard"
  end

  test "#category_title can be empty" do
    guide = presented_item(schema_name, "links" => {})
    assert_nil guide.category_title
  end

  test "#content_owners when stored in the links" do
    guide = presented_item(schema_name,
                           "details" => { "content_owner" => nil },
                           "links" => { "content_owners" => [{
                             "content_id" => "e5f09422-bf55-417c-b520-8a42cb409814",
                             "title" => "Agile delivery community",
                             "base_path" => "/service-manual/communities/agile-delivery-community",
                           }] })

    expected = [
      ServiceManualGuidePresenter::ContentOwner.new(
        "Agile delivery community",
        "/service-manual/communities/agile-delivery-community",
      ),
    ]
    assert_equal expected, guide.content_owners
  end

  test "#show_description? is false if not set" do
    assert_not presented_item(schema_name, {}).show_description?
  end

  test "#public_updated_at returns a time" do
    assert_kind_of Time, presented_item.public_updated_at
  end

  test "#public_updated_at returns nil if not available" do
    example = govuk_content_schema_example("service_manual_guide", "service_manual_guide")
    content_item = example.merge("public_updated_at" => nil)
    guide = present_example(content_item)

    assert_nil guide.public_updated_at
  end

  test "#visible_updated_at returns the public_updated_at" do
    timestamp = "2015-10-10T09:00:00+00:00"
    guide = presented_item(schema_name, "public_updated_at" => timestamp)

    assert_equal guide.visible_updated_at, Time.zone.parse(timestamp)
  end

  test "#visible_updated_at returns the updated_at time if the public_updated_at hasn't yet been set" do
    timestamp = "2015-10-10T09:00:00+00:00"
    example = schema_item("service_manual_guide", "service_manual_guide")
    content_item = example.merge("updated_at" => timestamp, "public_updated_at" => nil)
    guide = present_example(content_item)

    assert_equal guide.visible_updated_at, Time.zone.parse(timestamp)
  end

  test "#latest_change returns the details for the most recent change" do
    expected_history = ServiceManualGuidePresenter::Change.new(
      Time.zone.parse("2015-10-09T08:17:10+00:00"),
      "This is our latest change",
    )

    assert_equal expected_history, presented_item.latest_change
  end

  test "#latest_change timestamp is the updated_at time if public_updated_at hasn't been set" do
    timestamp = "2015-10-07T09:00:00+00:00"
    example = schema_item("service_manual_guide", "service_manual_guide")
    content_item = example.merge("updated_at" => timestamp, "public_updated_at" => nil)
    guide = present_example(content_item)

    expected_history = ServiceManualGuidePresenter::Change.new(
      Time.zone.parse(timestamp),
      "This is our latest change",
    )

    assert_equal expected_history, guide.latest_change
  end

  test "#previous_changes returns the change history for the guide" do
    expected_history = [
      ServiceManualGuidePresenter::Change.new(
        Time.zone.parse("2015-09-09T08:17:10+00:00"),
        "This is another change",
      ),
      ServiceManualGuidePresenter::Change.new(
        Time.zone.parse("2015-09-01T08:17:10+00:00"),
        "Guidance first published",
      ),
    ]

    assert_equal expected_history, presented_item.previous_changes
  end

  test "#header_links returns a list of hrefs and text" do
    assert_equal [{ "text" => "What is it, why it works and how to do it", "href" => "#what-is-it-why-it-works-and-how-to-do-it" }], presented_item.header_links
  end
end
