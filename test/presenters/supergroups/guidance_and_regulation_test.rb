require 'test_helper'

class GuidanceAndRegulationTest < ActiveSupport::TestCase
  include RummagerHelpers

  test "tagged_content returns empty array if taxon ids is a blank array" do
    guidance_and_regulation = Supergroups::GuidanceAndRegulation.new("/a-random-path", [], {})
    assert_equal [], guidance_and_regulation.tagged_content
  end

  test "tagged_content returns empty array if there are taxon ids but no results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']

    stub_most_popular_content("/a-random-path", taxon_content_ids, 0, "guidance_and_regulation")
    guidance_and_regulation = Supergroups::GuidanceAndRegulation.new("/a-random-path", [], {})
    assert_equal [], guidance_and_regulation.tagged_content
  end

  test "tagged_content returns array with 2 items if there are 2 results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']

    stub_most_popular_content("/a-random-path", taxon_content_ids, 2, "guidance_and_regulation")
    guidance_and_regulation = Supergroups::GuidanceAndRegulation.new("/a-random-path", taxon_content_ids, {})
    assert_equal 2, guidance_and_regulation.tagged_content.count
  end
end
