require "test_helper"
require './test/support/custom_assertions.rb'

class MostPopularContentTest < ActiveSupport::TestCase
  include RummagerHelpers

  def most_popular_content
    @most_popular_content ||= MostPopularContent.new(content_ids: taxon_content_ids, filter_content_purpose_supergroup: "guidance_and_regulation", number_of_links: 6)
  end

  def taxon_content_ids
    ['c3c860fc-a271-4114-b512-1c48c0f82564', 'ff0e8e1f-4dea-42ff-b1d5-f1ae37807af2']
  end

  test "orders the results by popularity in descending order" do
    assert_includes_params(order: '-popularity') do
      most_popular_content.fetch
    end
  end

  test "includes taxon ids" do
    assert_includes_params(filter_part_of_taxonomy_tree: taxon_content_ids) do
      most_popular_content.fetch
    end
  end

  test "returns number of links" do
    assert_includes_params(count: 6) do
      most_popular_content.fetch
    end
  end
end
