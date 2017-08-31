require 'component_test_helper'

class BackToTopTest < ComponentTestCase
  def component_name
    "back-to-top"
  end

  test "fails to render a back to top link when no parameters given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders a back to top link when a href is given" do
    render_component(href: "#contents")

    assert_select ".app-c-back-to-top[href='#contents']"
  end

  test "renders a back to top link with custom text" do
    render_component(href: "#contents", text: "Back to top")

    assert_select ".app-c-back-to-top[href='#contents']", text: "Back to top"
  end
end
