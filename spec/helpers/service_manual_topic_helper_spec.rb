RSpec.describe(ServiceManualTopicHelper, type: :view) do
  include ServiceManualTopicHelper

  describe "#topic_related_communities_title" do
    it "invites you to join the only related community" do
      communities = [{ title: "Agile delivery community" }]

      expect(topic_related_communities_title(communities)).to eq("Join the Agile delivery community")
    end

    it "invites you to join the community as a whole if there are multiple communities" do
      communities = [{ title: "Agile delivery community" }, { title: "User research community" }]

      expect(topic_related_communities_title(communities)).to eq("Join the community")
    end
  end
end
