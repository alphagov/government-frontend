require "test_helper"

require "nokogiri/html"
require "open-uri"
require "rss"

class TravelAdviceAtomFeed < ActionDispatch::IntegrationTest
  setup do
    setup_and_parse_travel_advice_atom_feed("full-country")
    @base_path = @content_item["base_path"]
    @updated_at = Time.zone.parse(@content_item["public_updated_at"])
  end

  test "it sets the alternative link correctly" do
    alternate_link = @feed.links.find { |link| link.rel == "alternate" }
    assert alternate_link.href.ends_with?(@base_path)
  end

  test "it sets the entry's id to the url concatenated with updated_at" do
    id = @feed.items.first.id.content
    assert id.end_with?("#{@base_path}##{@updated_at}")
  end

  test "it sets the entry's title correctly" do
    title = @feed.items.first.title.content
    assert_equal title, @content_item["title"]
  end

  test "it sets the entry's summary correctly" do
    summary = Nokogiri::HTML::fragment(@feed.items.first.summary.content)
    assert_equal summary.text.strip, @content_item["details"]["change_description"].strip
  end

  test "it sets the entry's updated correctly" do
    updated = @feed.items.first.updated.content
    assert_equal updated, @updated_at
  end

  def setup_and_parse_travel_advice_atom_feed(name)
    @content_item = get_content_example_by_schema_and_name("travel_advice", name)

    uri = URI::HTTP.build(
      host: Capybara.current_session.server.host,
      port: Capybara.current_session.server.port,
      path: "#{@content_item['base_path']}.atom",
    )

    stub_content_store_has_item(@content_item["base_path"], @content_item.to_json)

    @feed = RSS::Parser.parse(uri.read)
  end
end
