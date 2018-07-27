require 'test_helper'

class PolicyAndEngagementTest < ActiveSupport::TestCase
  include RummagerHelpers

  def taxon_content_ids
    ['c3c860fc-a271-4114-b512-1c48c0f82564', 'ff0e8e1f-4dea-42ff-b1d5-f1ae37807af2']
  end

  test "tagged_content returns empty array if taxon ids is a blank array" do
    policy_and_engagement = Supergroups::PolicyAndEngagement.new("/a-random-path", [])
    assert_equal [], policy_and_engagement.tagged_content
  end

  test "tagged_content returns empty array if there are taxon ids but no results" do
    stub_most_recent_content("/a-random-path", [], 0, "policy_and_engagement")
    policy_and_engagement = Supergroups::PolicyAndEngagement.new("/a-random-path", [])
    assert_equal [], policy_and_engagement.tagged_content
  end

  test "tagged_content returns array with 2 items if there are 2 results" do
    stub_most_recent_content("/a-random-path", taxon_content_ids, 2, "policy_and_engagement")
    policy_and_engagement = Supergroups::PolicyAndEngagement.new("/a-random-path", taxon_content_ids)
    assert_equal 2, policy_and_engagement.tagged_content.count
  end
end
