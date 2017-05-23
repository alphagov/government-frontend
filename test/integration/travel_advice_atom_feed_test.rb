require 'test_helper'

class TravelAdviceAtomFeed < ActionDispatch::IntegrationTest
  setup do
    setup_and_visit_travel_advice_atom_feed('full-country')
    @base_path = @content_item['base_path']
    @updated_at = DateTime.parse(@content_item["public_updated_at"]).rfc3339
  end

  test "it sets the alternative link correctly" do
    assert page.has_css?("feed>link[rel='alternate'][href$='#{@base_path}']")
  end

  test "it sets the entry's id to the url concatenated with updated_at" do
    id = page.find("feed>entry>id").text(:all)
    assert id.end_with?("#{@base_path}##{@updated_at}")
  end

  test "it sets the entry's title correctly" do
    title = page.find("feed>entry>title").text(:all)
    assert_equal title, @content_item['title']
  end

  test "it sets the entry's summary correctly" do
    summary = page.find("feed>entry>summary").text(:all)
    assert_equal summary, @content_item['details']['change_description'].strip
  end

  test "it sets the entry's updated correctly" do
    updated = page.find("feed>entry>updated").text(:all)
    assert_equal updated, @updated_at
  end

  def setup_and_visit_travel_advice_atom_feed(name)
    example = get_content_example_by_schema_and_name('travel_advice', name)
    @content_item = JSON.parse(example).tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit "#{item['base_path']}.atom"
    end
  end
end
