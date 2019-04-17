require 'test_helper'

class GuidePrint < ActionDispatch::IntegrationTest
  test "it renders the print view" do
    setup_and_visit_guide_print('guide')
    assert page.has_css?("#guide-print")
  end

  test "it is not indexable by search engines" do
    setup_and_visit_guide_print('guide')
    assert page.has_css?("meta[name='robots'][content='noindex, nofollow']", visible: false)
  end

  test "it renders all parts in the print view" do
    setup_and_visit_guide_print('guide')
    parts = @content_item['details']['parts']

    parts.each_with_index do |part, i|
      assert page.has_css?("h1", text: "#{i + 1}. #{part['title']}")
    end

    assert page.has_content?("The ‘basic’ school curriculum includes the")
  end

  def setup_and_visit_guide_print(name)
    example = get_content_example_by_schema_and_name('guide', name)
    @content_item = example.tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit "#{item['base_path']}/print"
    end
  end
end
