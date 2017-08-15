require 'component_test_helper'

class FigureTest < ComponentTestCase
  def component_name
    "figure"
  end

  test "fails to render a figure when no data is given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders a figure correctly" do
    render_component(src: '/image', alt: 'image alt text')
    assert_select ".app-c-figure__image[src=\"/image\"]"
    assert_select ".app-c-figure__image[alt=\"image alt text\"]"
  end

  test "renders a figure with caption correctly" do
    render_component(src: '/image', alt: 'image alt text', caption: 'This is a caption')
    assert_select ".app-c-figure__image[src=\"/image\"]"
    assert_select ".app-c-figure__image[alt=\"image alt text\"]"
    assert_select ".app-c-figure__figcaption", text: 'This is a caption'
  end
end
