require "component_test_helper"

class DownloadLinkTest < ComponentTestCase
  def component_name
    "download-link"
  end

  test "fails to render a download link when no href is given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders a download link correctly" do
    render_component(href: "/download-me")
    assert_select ".app-c-download-link[href=\"/download-me\"]"
  end

  test "renders a download link with custom link text correctly" do
    render_component(href: "/download-map", link_text: "Download this file")
    assert_select ".app-c-download-link[href=\"/download-map\"]", text: "Download this file"
  end
end
