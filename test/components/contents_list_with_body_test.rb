require 'component_test_helper'

class ContentsListWithBodyTest < ComponentTestCase
  def component_path
    "components/contents-list-with-body"
  end

  def contents_list
    [
      { href: '/one', text: "1. One" },
      { href: '/two', text: "2. Two" }
    ]
  end

  def block
    "<p>Foo</p>".html_safe
  end

  test "renders nothing without a block" do
    assert_empty render(component_path, contents: contents_list)
  end

  test "yields the block without contents data" do
    assert_includes(render(component_path, {}) { block }, block)
  end

  test "renders a sticky-element-container" do
    render(component_path, contents: contents_list) { block }

    assert_select("#contents.app-c-contents-list-with-body")
    assert_select("#contents[data-module='sticky-element-container']")
  end

  test "does not apply the sticky-element-container data-module without contents data" do
    render(component_path, {}) { block }

    assert_select("#contents[data-module='sticky-element-container']", count: 0)
  end

  test "renders a contents-list component" do
    render(component_path, contents: contents_list) { block }

    assert_select(".app-c-contents-list-with-body .app-c-contents-list")
    assert_select ".app-c-contents-list__link[href='/one']", text: "1. One"
  end

  test "renders a back-to-top component" do
    render(component_path, contents: contents_list) { block }

    assert_select(%(.app-c-contents-list-with-body
                    .app-c-contents-list-with-body__link-wrapper
                    .app-c-contents-list-with-body__link-container
                    .app-c-back-to-top[href='#contents']))
  end
end
