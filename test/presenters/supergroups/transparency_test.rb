require 'test_helper'

class TransparencyTest < ActiveSupport::TestCase
  include RummagerHelpers

  test "tagged_content returns empty array if taxon ids is a blank array" do
    policy_and_engagement = Supergroups::Transparency.new("/a-random-path", [], {})
    assert_equal [], policy_and_engagement.tagged_content
  end

  test "tagged_content returns empty array if there are taxon ids but no results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']

    stub_most_recent_content("/a-random-path", taxon_content_ids, 0, "transparency")
    policy_and_engagement = Supergroups::Transparency.new("/a-random-path", [], {})
    assert_equal [], policy_and_engagement.tagged_content
  end

  test "tagged_content returns array with 2 items if there are 2 results" do
    taxon_content_ids = ['any-old-taxon', 'some-other-taxon-id']

    stub_most_recent_content("/a-random-path", taxon_content_ids, 2, "transparency")
    policy_and_engagement = Supergroups::Transparency.new("/a-random-path", taxon_content_ids, {})
    assert_equal 2, policy_and_engagement.tagged_content.count
  end
end
