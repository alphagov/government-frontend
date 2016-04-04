require 'test_helper'

class ServiceManualTopicHelperTest < ActionView::TestCase
  test "service_manual_topic_related_communities_title invites you to join the only related community" do
    communities = [{ title: "Agile delivery community" }]

    assert_equal "Join the Agile delivery community",
      service_manual_topic_related_communities_title(communities)
  end

  test "service_manual_topic_related_communities_title invites you to join the community as a " \
    "whole if there are multiple communities" do
    communities = [{ title: "Agile delivery community" }, { title: "User research community" }]

    assert_equal "Join the community",
      service_manual_topic_related_communities_title(communities)
  end
end
