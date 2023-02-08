require "test_helper"

class ServiceManualTopicHelperTest < ActionView::TestCase
  test "topic_related_communities_title invites you to join the only related community" do
    communities = [{ title: "Agile delivery community" }]

    assert_equal "Join the Agile delivery community",
                 topic_related_communities_title(communities)
  end

  test "topic_related_communities_title invites you to join the community as a " \
    "whole if there are multiple communities" do
    communities = [{ title: "Agile delivery community" }, { title: "User research community" }]

    assert_equal "Join the community",
                 topic_related_communities_title(communities)
  end
end
