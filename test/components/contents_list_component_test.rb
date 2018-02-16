require 'component_test_helper'

class ContentsListComponentTest < ComponentTestCase
  def component_name
    "contents-list"
  end

  def contents_list
    [
      { href: '/one', text: "1. One" },
      { href: '/two', text: "2. Two" }
    ]
  end

  def contents_list_with_active_item
    [
      { href: '/one', text: "1. One" },
      { href: '/two', text: "2. Two", active: true },
      { href: '/three', text: "3. Three" }
    ]
  end

  def nested_contents_list
    contents_list << {
                       href: '/three',
                       text: "3. Three",
                       items: [
                         { href: '/nested-one', text: "Nested one" },
                         { href: '/nested-two', text: "Nested two" },
                         { href: '/nested-four', text: "4. Four" },
                       ]
                     }
  end

  def assert_tracking_link(name, value, total = 1)
    assert_select "a[data-track-#{name}='#{value}']", total
  end

  test "renders nothing without provided contents" do
    assert_empty render_component({})
  end

  test "renders a list of contents links" do
    render_component(contents: contents_list)
    assert_select ".app-c-contents-list"
    assert_select ".app-c-contents-list__link[href='/one']", text: "1. One"
    assert_select ".app-c-contents-list__link[href='/two']", text: "2. Two"
  end

  test "renders text only when link is active" do
    render_component(contents: contents_list_with_active_item)
    assert_select ".app-c-contents-list"
    assert_select ".app-c-contents-list__link[href='/one']", text: "1. One"
    assert_select ".app-c-contents-list__link[href='/two']", count: 0
    assert_select ".app-c-contents-list__list-item[2]", text: '2. Two'
    assert_select ".app-c-contents-list__list-item--active[aria-current='true']"
  end

  test "renders text only when link is active for numbered lists" do
    render_component(contents: contents_list_with_active_item, format_numbers: true)
    assert_select ".app-c-contents-list"
    assert_select ".app-c-contents-list__link[href='/one']", text: "1. One"
    assert_select ".app-c-contents-list__link[href='/two']", count: 0
    assert_select ".app-c-contents-list__list-item[2]", text: '2. Two'
    assert_select ".app-c-contents-list__list-item[2] .app-c-contents-list__number", text: '2.'
    assert_select ".app-c-contents-list__list-item--active[aria-current='true']"
  end

  test "renders a nested list of contents links" do
    render_component(contents: nested_contents_list)
    nested_link_selector = ".app-c-contents-list__list-item--parent ol li .app-c-contents-list__link"

    assert_select "#{nested_link_selector}[href='/nested-one']", text: "Nested one"
    assert_select "#{nested_link_selector}[href='/nested-two']", text: "Nested two"
  end

  test "renders data attributes for tracking" do
    render_component(contents: nested_contents_list)

    assert_tracking_link("category", "contentsClicked", 6)
    assert_tracking_link("action", "content_item 1")
    assert_tracking_link("label", "/one")
    assert_tracking_link("options", { dimension29: "1. One" }.to_json)

    assert_tracking_link("action", "nested_content_item 3:1")
    assert_tracking_link("label", "/nested-one")
    assert_tracking_link("options", { dimension29: "Nested one" }.to_json)
  end


  test "formats numbers in contents links" do
    render_component(contents: contents_list, format_numbers: true)
    link_selector = ".app-c-contents-list__list-item--numbered a[href='/one']"

    assert_select "#{link_selector} .app-c-contents-list__number", text: "1."
    assert_select "#{link_selector} .app-c-contents-list__numbered-text", text: "One"
  end

  test "does not format numbers in a nested list" do
    render_component(contents: nested_contents_list, format_numbers: true)

    link_selector = ".app-c-contents-list__list-item--parent a[href='/one']"
    assert_select "#{link_selector} .app-c-contents-list__number", text: "1."
    assert_select "#{link_selector} .app-c-contents-list__numbered-text", text: "One"

    nested_link_selector = ".app-c-contents-list__list-item--parent ol li a[href='/nested-four']"
    assert_select "#{nested_link_selector} .app-c-contents-list__number", count: 0
    assert_select "#{nested_link_selector} .app-c-contents-list__numbered-text", count: 0
  end

  test "aria label is rendered when supplied" do
    render_component(contents: contents_list_with_active_item, aria_label: "All pages in this guide")
    assert_select ".app-c-contents-list[aria-label=\"All pages in this guide\"]"
  end
end
