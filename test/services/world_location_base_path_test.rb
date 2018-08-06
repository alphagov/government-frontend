require "test_helper"

class WorldLocationBasePathWhenPathExists < ActiveSupport::TestCase
  test "returns the base_path" do
    link = {
      "base_path" => "/government/world/usa",
      "government" => "USA"
    }
    assert_equal "/government/world/usa", WorldLocationBasePath.for(link)
  end
end

class WorldLocationBasePathWithoutBasePath < ActiveSupport::TestCase
  test "returns /world/usa/news" do
    link = {
      "title" => "USA"
    }
    assert_equal "/world/usa/news", WorldLocationBasePath.for(link)
  end
end

class WorldLocationBasePathForExceptionalCase < ActiveSupport::TestCase
  {
   "Democratic Republic of Congo" => "democratic-republic-of-congo",
   "South Georgia and the South Sandwich Islands" => "south-georgia-and-south-sandwich-islands",
   "St Pierre & Miquelon" => "st-pierre-miquelon"
  }.each do |title, expected_slug|
    test "returns /world/#{expected_slug}/news" do
      link = {
        "title" => title
      }
      assert_equal "/world/#{expected_slug}/news", WorldLocationBasePath.for(link)
    end
  end
end
