RSpec.describe("BackToTop", type: :view) do
  def component_name
    "back_to_top"
  end

  it "raises an error when no parameters given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "renders when a href is given" do
    render_component(href: "#contents")

    assert_select(".app-c-back-to-top[href='#contents']")
  end

  it "renders with custom text" do
    render_component(href: "#contents", text: "Back to top")

    assert_select(".app-c-back-to-top[href='#contents']", text: "Back to top")
  end
end
