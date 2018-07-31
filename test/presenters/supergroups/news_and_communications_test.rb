require 'test_helper'

class NewsAndCommunicationsTest < ActiveSupport::TestCase
  include RummagerHelpers

  test "finds no results if taxon ids is a blank array" do
    news_and_comms = Supergroups::NewsAndCommunications.new("/a-random-path", [])
    refute news_and_comms.any_news?
  end

  test "finds no results if there are taxon ids but no results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']

    stub_most_recent_content("/a-random-path", taxon_content_ids, 0, "news_and_communications")
    news_and_comms = Supergroups::NewsAndCommunications.new("/a-random-path", taxon_content_ids)
    refute news_and_comms.any_news?
  end

  test "finds 2 featured items and 0 normal items with 2 results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']
    stub_most_recent_content("/a-random-path", taxon_content_ids, 2, "news_and_communications")
    stub_content_store_items(2)

    news_and_comms = Supergroups::NewsAndCommunications.new("/a-random-path", taxon_content_ids)

    assert news_and_comms.any_news?
    assert_equal 0, news_and_comms.tagged_content.count
    assert_equal 2, news_and_comms.promoted_content.count
  end

  test "finds 3 promoted items and 2 normal items if there are enough results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']
    stub_most_recent_content("/a-random-path", taxon_content_ids, 5, "news_and_communications")
    stub_content_store_items(3)

    news_and_comms = Supergroups::NewsAndCommunications.new("/a-random-path", taxon_content_ids)

    news_and_comms.any_news?
    assert_equal 2, news_and_comms.tagged_content.count
    assert_equal 3, news_and_comms.promoted_content.count
  end

  test "promoted content includes placeholder images if the content doesn't have one" do
    placeholder_image = "https://assets.publishing.service.gov.uk/government/assets/placeholder.jpg"
    taxon_content_ids = ['any-old-taxon']
    stub_most_recent_content("/a-random-path", taxon_content_ids, 1, "news_and_communications")
    stub_content_store_items(1)

    news_and_comms = Supergroups::NewsAndCommunications.new("/a-random-path", taxon_content_ids)

    news_item = news_and_comms.promoted_content.first

    assert_equal news_item[:image][:url], placeholder_image
  end

  test "promoted content includes the content image URL if the content has one" do
    taxon_content_ids = ['any-old-taxon']
    stub_most_recent_content("/a-random-path", taxon_content_ids, 1, "news_and_communications")

    content = content_item_for_base_path("/content-item-0").merge(
      "details": {
        "image": {
          "url": "an/image/path",
          "alt_text": "some alt text"
        }
      }
    )
    content_store_has_item("/content-item-0", content)

    news_and_comms = Supergroups::NewsAndCommunications.new("/a-random-path", taxon_content_ids)

    news_item = news_and_comms.promoted_content.first

    assert_equal news_item[:image][:url], "an/image/path"
  end

  def stub_content_store_items(count)
    count.times.map do |i|
      content_store_has_item("/content-item-#{i}")
    end
  end
end
