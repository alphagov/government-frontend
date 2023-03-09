require "test_helper"

class FieldsOfOperationTest < ActionDispatch::IntegrationTest
  test "renders the relevant information on the page" do
    setup_and_visit_content_item("fields_of_operation")

    assert page.has_title?("Fields of operation - GOV.UK")

    assert_has_component_title("Fields of operation")

    assert page.has_link? "A field of operation", href: "/government/fields-of-operation/field-of-operation-one"
    assert page.has_link? "Another field of operation", href: "/government/fields-of-operation/field-of-operation-two"
  end
end
