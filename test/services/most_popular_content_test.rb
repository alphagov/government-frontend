require 'test_helper'

class MostPopularContentTest < ActiveSupport::TestCase
  include RummagerFields

  def most_popular_content
    @most_popular_content ||= MostPopularContent.new(
      content_id: taxon_content_id,
      filter_content_purpose_supergroup: 'guidance_and_regulation'
    )
  end

  def taxon_content_id
    'c3c860fc-a271-4114-b512-1c48c0f82564'
  end

  test 'returns the results from search' do
    search_results = {
      'results' => [
        { 'title' => 'Doc 1' },
        { 'title' => 'A Doc 2' },
      ]
    }

    Services.rummager.stubs(:search).returns(search_results)

    results = most_popular_content.fetch
    assert_equal(results.count, 2)
  end

  test 'starts from the first page' do
    assert_includes_params(start: 0) do
      most_popular_content.fetch
    end
  end

  test 'requests five results by default' do
    assert_includes_params(count: 5) do
      most_popular_content.fetch
    end
  end

  test 'requests a limited number of fields' do
    fields = RummagerFields::TAXON_SEARCH_FIELDS

    assert_includes_params(fields: fields) do
      most_popular_content.fetch
    end
  end

  test 'orders the results by popularity in descending order' do
    assert_includes_params(order: '-popularity') do
      most_popular_content.fetch
    end
  end

  test 'scopes the results to the current taxon' do
    assert_includes_params(filter_part_of_taxonomy_tree: Array(taxon_content_id)) do
      most_popular_content.fetch
    end
  end

  test 'filters content by the requested filter_content_purpose_supergroup only' do
    assert_includes_params(filter_content_purpose_supergroup: 'guidance_and_regulation') do
      most_popular_content.fetch
    end
  end

  def assert_includes_params(expected_params)
    search_results = {
      'results' => [
        {
          'title' => 'Doc 1'
        },
        {
          'title' => 'Doc 2'
        }
      ]
    }

    Services.
      rummager.
      stubs(:search).
      with { |params| params.including?(expected_params) }.
      returns(search_results)

    results = yield

    assert_equal(results.count, 2)

    assert_equal(results.first.title, 'Doc 1')
    assert_equal(results.last.title, 'Doc 2')
  end
end
