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

  test "renders nothing without provided contents" do
    assert_empty render_component({})
  end

  test "renders a list of contents links" do
    render_component(contents: contents_list)
    assert_select ".app-c-contents-list"
    assert_select ".app-c-contents-list__link[href='/one']", text: "1. One"
    assert_select ".app-c-contents-list__link[href='/two']", text: "2. Two"
  end

  test "renders a nested list of contents links" do
    render_component(contents: nested_contents_list)
    nested_link_selector = ".app-c-contents-list__list-item--parent ol li .app-c-contents-list__link"

    assert_select "#{nested_link_selector}[href='/nested-one']", text: "Nested one"
    assert_select "#{nested_link_selector}[href='/nested-two']", text: "Nested two"
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
end
