require 'component_test_helper'

class HeadingTest < ComponentTestCase
  def component_name
    "heading"
  end

  test "fails to render a heading when no title is given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders a heading correctly" do
    render_component(text: 'Download documents')
    assert_select "h1.app-c-heading", text: 'Download documents'
  end

  test "renders a different heading level" do
    render_component(text: 'Original consultation', heading_level: 3)
    assert_select "h3.app-c-heading", text: 'Original consultation'
  end

  test "has a specified id attribute" do
    render_component(text: 'Consultation description', id: 'custom-id')
    assert_select ".app-c-heading[id='custom-id']", text: 'Consultation description'
  end
end
