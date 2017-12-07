require 'component_test_helper'

class BackLinkTest < ComponentTestCase
  def component_name
    "back-link"
  end

  test "fails to render a back link when no href is given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders a back link correctly" do
    render_component(href: '/back-me')
    assert_select ".app-c-back-link[href=\"/back-me\"]", text: "Back"
  end
end
