require "component_test_helper"

class ErrorMessageTest < ComponentTestCase
  def component_name
    "error-message"
  end

  test "fails to render no data is given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders an error message correctly" do
    render_component(text: "Descriptive error message")
    assert_select ".app-c-error-message", text: "Descriptive error message"
  end

  test "renders an error message with an id" do
    render_component(text: "Descriptive error message with id", id: "unique-error-id")
    assert_select ".app-c-error-message[id='unique-error-id']", text: "Descriptive error message with id"
  end
end
