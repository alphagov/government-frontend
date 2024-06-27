RSpec.describe("ContentsListWithBody", type: :view) do
  def component_path
    "components/contents_list_with_body"
  end

  def contents_list
    [{ href: "/one", text: "1. One" }, { href: "/two", text: "2. Two" }]
  end

  def block
    "<p>Foo</p>".html_safe
  end

  it "renders nothing without a block" do
    expect(render(component_path, contents: contents_list)).to be_empty
  end

  it "yields the block without contents data" do
    assert_includes(render(component_path, {}) { block }, block)
  end

  it "renders a sticky-element-container" do
    render(component_path, contents: contents_list) { block }

    assert_select("#contents.app-c-contents-list-with-body")
    assert_select("#contents[data-module='sticky-element-container']")
  end

  it "does not apply the sticky-element-container data-module without contents data" do
    render(component_path, {}) { block }

    assert_select("#contents[data-module='sticky-element-container']", count: 0)
  end

  it "renders a contents-list component" do
    render(component_path, contents: contents_list) { block }

    assert_select(".app-c-contents-list-with-body .gem-c-contents-list")
    assert_select(".gem-c-contents-list__link[href='/one']", text: "1. One")
  end

  it "renders a back-to-top component" do
    render(component_path, contents: contents_list) { block }

    assert_select(".app-c-contents-list-with-body\n                    .app-c-contents-list-with-body__link-wrapper\n                    .app-c-contents-list-with-body__link-container\n                    .app-c-back-to-top[href='#contents']")
  end
end
