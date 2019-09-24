require "component_test_helper"

class PrintLinkTest < ComponentTestCase
  def component_name
    "print-link"
  end

  test "fails to render a print link when no href is given" do
    assert_raise do
      render_component({})
    end
  end

  test "fails to render a print link when no href is given but custom text is" do
    assert_raise do
      render_component(link_text: "test")
    end
  end

  test "renders a print link correctly" do
    render_component(href: "#")
    assert_select ".app-c-print-link .app-c-print-link__link[href=\"#\"]"
  end

  test "renders a print link with custom link text correctly" do
    render_component(href: "#print", link_text: "Some new link text")
    assert_select ".app-c-print-link .app-c-print-link__link[href=\"#print\"]", text: "Some new link text"
  end
end
