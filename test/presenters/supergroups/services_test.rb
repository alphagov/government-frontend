require 'test_helper'

class ServicesTest < ActiveSupport::TestCase
  include RummagerHelpers

  test "services returns no results if taxon ids is a blank array" do
    services = Supergroups::Services.new("/a-random-path", [], {})
    assert_equal [], services.tagged_content
  end

  test "services returns no results if there are taxon ids but no results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']

    stub_most_popular_content("/a-random-path", taxon_content_ids, 0, "services")
    services = Supergroups::Services.new("/a-random-path", taxon_content_ids, {})
    assert_equal [], services.tagged_content
  end

  test "tagged_content returns hash with with 2 featured items and 0 normal items with 2 results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']

    stub_most_popular_content("/a-random-path", taxon_content_ids, 2, "services")

    services = Supergroups::Services.new("/a-random-path", taxon_content_ids, {})

    assert_equal 2, services.tagged_content.count
  end

  test "tagged_content returns hash with with 3 featured items and 2 normal items if there are enough results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']

    stub_most_popular_content("/a-random-path", taxon_content_ids, 3, "services")

    services = Supergroups::Services.new("/a-random-path", taxon_content_ids, {})

    assert_equal 3, services.tagged_content.count
  end
end
