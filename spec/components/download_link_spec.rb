RSpec.describe("DownloadLink", type: :view) do
  def component_name
    "download_link"
  end

  it "raises an error when no href given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "renders" do
    render_component(href: "/download-me")

    assert_select(".app-c-download-link[href=\"/download-me\"]")
  end

  it "renders with custom link text" do
    render_component(href: "/download-map", link_text: "Download this file")

    assert_select(".app-c-download-link[href=\"/download-map\"]", text: "Download this file")
  end
end
