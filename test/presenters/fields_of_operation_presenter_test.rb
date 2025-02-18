require "presenter_test_helper"

class FieldsOfOperationPresenterTest < PresenterTestCase
  def schema_name
    "fields_of_operation"
  end

  test "presents the heading and context" do
    heading_component_params = {
      text: "Fields of operation",
      context: "British fatalities",
      context_locale: :en,
      heading_level: 1,
      margin_bottom: 8,
      font_size: "xl",
    }

    assert_equal heading_component_params, presented_item.heading_and_context
  end

  test "presents the fields of operation" do
    expected_fields_of_operation = [
      ["A field of operation", "/government/fields-of-operation/field-of-operation-one"],
      ["Another field of operation", "/government/fields-of-operation/field-of-operation-two"],
    ]

    assert_equal expected_fields_of_operation, presented_item.fields_of_operation
  end
end
