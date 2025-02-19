require "presenter_test_helper"

class FieldOfOperationPresenterTest < PresenterTestCase
  def schema_name
    "field_of_operation"
  end

  test "#heading_and_context" do
    expected_heading_and_context = {
      text: "Operations in Iraq",
      context: "British fatalities",
      context_locale: :en,
      heading_level: 1,
      margin_bottom: 8,
      font_size: "xl",
    }
    assert_equal expected_heading_and_context, presented_item.heading_and_context
  end

  test "it presents a description" do
    assert_equal "It is with very deep regret that the following fatalities are announced.", presented_item.description
  end

  test "it presents the organisations object" do
    expected = {
      name: "Ministry<br/>of Defence",
      url: "/government/organisations/ministry-of-defence",
      brand: "ministry-of-defence",
      crest: "mod",
    }

    assert_equal expected, presented_item.organisation
  end

  test "it presents fatality notices when they are present" do
    expected_notices = [
      FieldOfOperationPresenter::FatalityNotice.new("A fatality sadly occurred on 1 December", nil, "A fatality notice", "/government/fatalities/fatality-notice-one"),
      FieldOfOperationPresenter::FatalityNotice.new("A fatality sadly occurred on 2 December", nil, "A second fatality notice", "/government/fatalities/fatality-notice-two"),
    ]

    assert_equal expected_notices, presented_item.fatality_notices
  end

  test "it presents an empty array when no fatality notices are present" do
    without_fatalities = schema_item
    without_fatalities["links"].delete("fatality_notices")

    presented = create_presenter(FieldOfOperationPresenter, content_item: without_fatalities)

    assert_equal [], presented.fatality_notices
  end

  test "it presents contents when fields of operation and fatalities are present" do
    expected = [
      { href: "#field-of-operation", text: "Field of operation" },
      { href: "#fatalities", text: "Fatalities" },
    ]

    assert_equal expected, presented_item.contents
  end

  test "it presents contents when only fields of operation are present" do
    without_fatalities = schema_item
    without_fatalities["links"].delete("fatality_notices")

    presented = create_presenter(FieldOfOperationPresenter, content_item: without_fatalities)

    expected = [
      { href: "#field-of-operation", text: "Field of operation" },
    ]

    assert_equal expected, presented.contents
  end

  test "it presents contents when only fatalities are present" do
    without_description = schema_item
    without_description.delete("description")

    presented = create_presenter(FieldOfOperationPresenter, content_item: without_description)

    expected = [
      { href: "#fatalities", text: "Fatalities" },
    ]

    assert_equal expected, presented.contents
  end

  test "it presents an empty array when neither fatalities nor description are present" do
    without_description_or_fatalities = schema_item
    without_description_or_fatalities.delete("description")
    without_description_or_fatalities["links"].delete("fatality_notices")

    presented = create_presenter(FieldOfOperationPresenter, content_item: without_description_or_fatalities)

    assert_equal [], presented.contents
  end
end
