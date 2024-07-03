RSpec.describe(WorldLocationBasePath, type: :model) do
  context "when the base path exists" do
    it "returns the base_path" do
      link = { "base_path" => "/government/world/usa", "government" => "USA" }
      expect(WorldLocationBasePath.for(link)).to eq("/government/world/usa")
    end
  end

  context "when the base path doesn't exist" do
    it "returns an appropriate news page from the title" do
      link = { "title" => "USA" }
      expect(WorldLocationBasePath.for(link)).to eq("/world/usa/news")
    end

    { "Democratic Republic of Congo" => "democratic-republic-of-congo", "South Georgia and the South Sandwich Islands" => "south-georgia-and-the-south-sandwich-islands", "St Pierre & Miquelon" => "st-pierre-miquelon" }.each do |title, expected_slug|
      it "returns /world/#{expected_slug}/news when the title is #{title}"  do
        link = { "title" => title }
        expect(WorldLocationBasePath.for(link)).to eq("/world/#{expected_slug}/news")
      end
    end
  end
end
