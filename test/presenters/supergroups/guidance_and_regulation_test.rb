require 'test_helper'

class GuidanceAndRegulationTest < ActiveSupport::TestCase
  include RummagerHelpers

  def taxon_content_ids
    ['c3c860fc-a271-4114-b512-1c48c0f82564', 'ff0e8e1f-4dea-42ff-b1d5-f1ae37807af2']
  end

  test "tagged_content returns empty array if taxon ids is a blank array" do
    guidance_and_regulation = Supergroups::GuidanceAndRegulation.new("/no-particular-page", [])
    assert_equal [], guidance_and_regulation.tagged_content
  end

  test "tagged_content returns empty array if there are taxon ids but no results" do
    stub_most_popular_content("/no-particular-page", [], 0, "guidance_and_regulation")
    guidance_and_regulation = Supergroups::GuidanceAndRegulation.new("/no-particular-page", [])
    assert_equal [], guidance_and_regulation.tagged_content
  end

  test "tagged_content returns array with 2 items if there are 2 results" do
    stub_most_popular_content("/no-particular-page", taxon_content_ids, 2, "guidance_and_regulation")
    guidance_and_regulation = Supergroups::GuidanceAndRegulation.new("/no-particular-page", taxon_content_ids)
    assert_equal 2, guidance_and_regulation.tagged_content.count
  end
end
