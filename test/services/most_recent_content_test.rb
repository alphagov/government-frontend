require "test_helper"
require './test/support/custom_assertions.rb'

class MostRecentContentTest < ActiveSupport::TestCase
  include RummagerHelpers

  def most_recent_content
    @most_recent_content ||= MostRecentContent.new(
      content_ids: taxon_content_ids,
      current_path: "/some-path",
      filters: { filter_content_purpose_supergroup: 'guidance_and_regulation', filter_content_purpose_subgroup: ['guidance'] },
      number_of_links: 6
    )
  end

  test 'catches api errors' do
    Services.rummager.stubs(:search).raises(GdsApi::HTTPErrorResponse.new(500))
    results = most_recent_content.fetch

    assert_equal(results, [])
  end

  def taxon_content_ids
    ['c3c860fc-a271-4114-b512-1c48c0f82564', 'ff0e8e1f-4dea-42ff-b1d5-f1ae37807af2']
  end

  test "orders the results by popularity in descending order" do
    assert_includes_params(order: '-public_timestamp') do
      most_recent_content.fetch
    end
  end

  test "includes taxon ids" do
    assert_includes_params(filter_part_of_taxonomy_tree: taxon_content_ids) do
      most_recent_content.fetch
    end
  end

  test "returns number of links plus one" do
    assert_includes_params(count: 7) do
      most_recent_content.fetch
    end
  end

  test "filters content by the requested filter_content_purpose_subgroups" do
    assert_includes_params(filter_content_purpose_subgroup: ["guidance"]) do
      most_recent_content.fetch
    end
  end

  test "rejects the originating page from the results" do
    search_results = {
        'results' => [
            {
                'title' => 'Doc 1',
                'link' => 'documents/1'
            },
            {
                'title' => 'Doc 2',
                'link' => 'documents/2'
            },
            {
                'title' => 'Some path',
                'link' => '/some-path'
            }
        ]
    }

    Services.
        rummager.
        stubs(:search).
        returns(search_results)

    results = most_recent_content.fetch
    links = results.map { |link| link['link'] }
    refute links.include?('/some-path')
    assert links.include?('documents/1')
    assert links.include?('documents/2')
  end
end
