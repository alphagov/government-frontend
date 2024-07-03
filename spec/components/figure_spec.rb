RSpec.describe("Figure", type: :view) do
  def component_name
    "figure"
  end

  it "raises an error when no data given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "does not render an image when no source is given" do
    render_component(src: "", alt: "")

    assert_select("img", false, "Should not have drawn img tag with no src")
  end

  it "renders" do
    render_component(src: "/image", alt: "image alt text")

    assert_select(".app-c-figure__image[src=\"/image\"]")
    assert_select(".app-c-figure__image[alt=\"image alt text\"]")
  end

  it "renders with caption" do
    render_component(src: "/image", alt: "image alt text", caption: "This is a caption")

    assert_select(".app-c-figure__image[src=\"/image\"]")
    assert_select(".app-c-figure__image[alt=\"image alt text\"]")
    assert_select(".app-c-figure__figcaption .app-c-figure__figcaption-text", text: "This is a caption")
  end

  it "renders with credit" do
    render_component(src: "/image", alt: "image alt text", credit: "Creative Commons")

    assert_select(".app-c-figure__image[src=\"/image\"]")
    assert_select(".app-c-figure__image[alt=\"image alt text\"]")
    assert_select(".app-c-figure__figcaption .app-c-figure__figcaption-credit", text: "Image credit: Creative Commons")
  end

  it "renders with caption and credit" do
    render_component(src: "/image", alt: "image alt text", caption: "This is a caption", credit: "Creative Commons")

    assert_select(".app-c-figure__image[src=\"/image\"]")
    assert_select(".app-c-figure__image[alt=\"image alt text\"]")
    assert_select(".app-c-figure__figcaption .app-c-figure__figcaption-text", text: "This is a caption")
    assert_select(".app-c-figure__figcaption .app-c-figure__figcaption-credit", text: "Image credit: Creative Commons")
  end
end
