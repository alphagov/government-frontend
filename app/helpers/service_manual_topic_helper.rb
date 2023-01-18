module ServiceManualTopicHelper
  def topic_related_communities_title(communities)
    if communities.length == 1
      "Join the #{communities.first[:title]}"
    else
      "Join the community"
    end
  end
end
