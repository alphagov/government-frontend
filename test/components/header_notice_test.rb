require "component_test_helper"

class HeaderNoticeTest < ComponentTestCase
  def component_name
    "header-notice"
  end

  test "doesn't render a header notice when no params are given" do
    assert_empty render_component({})
  end

  test "doesn't render a header notice when no title is given" do
    assert_empty render_component(links: [{ title: "test", href: "/test" }], description: "description")
  end

  test "doesn't render a header notice when no description is given" do
    assert_empty render_component(links: [{ title: "test", href: "/test" }], title: "title")
  end

  test "renders a header notice with text correctly" do
    render_component(title: "This is an important notice", description: "This is some important information about the content.")

    assert_select ".app-c-header-notice__title", text: "This is an important notice"
    assert_select ".app-c-header-notice__content p", text: "This is some important information about the content."
  end

  test "renders a header notice with an aria label" do
    render_component(title: "This is an important notice", description: "This is some important information about the content.")
    assert_select "section[aria-label=notice]"
  end

  test "renders a header notice with one link" do
    render_component(title: "This is an important notice", description: "This is a description", links: [{ title: "test", href: "/test" }])

    assert_select ".app-c-header-notice__title", text: "This is an important notice"
    assert_select ".app-c-header-notice__content p", text: "This is a description"
    assert_select ".app-c-header-notice__link[href='/test']", text: "test"
  end

  test "renders a header notice with multiple links" do
    render_component(title: "This is an important notice", description: "This is a description", link_intro: "Look at these links: ", links: [{ title: "test", href: "/test" }, { title: "test2", href: "/test2" }])

    assert_select ".app-c-header-notice__title", text: "This is an important notice"
    assert_select ".app-c-header-notice__content p", text: "This is a description"
    assert_select ".app-c-header-notice__link-intro", text: "Look at these links:"
    assert_select ".app-c-header-notice__list .app-c-header-notice__link[href='/test']", text: "test"
    assert_select ".app-c-header-notice__list .app-c-header-notice__link[href='/test2']", text: "test2"
  end
end
