require 'test_helper'

class MostPopularContentTest < ActiveSupport::TestCase
  include RummagerFields
  include GdsApi::TestHelpers::Rummager

  def most_popular_content
    @most_popular_content ||= MostPopularContent.new(
      content_ids: taxon_content_ids,
      current_path: "/how-to-ride-a-bike",
      filters: { filter_content_purpose_supergroup: 'guidance_and_regulation', filter_content_purpose_subgroup: ['guidance'] }
    )
  end

  def taxon_content_ids
    ['something-id-like', 'some-other-id']
  end

  test 'returns the results from search' do
    search_results = {
      body: {
        'results' => [
          { 'title' => 'Doc 1' },
          { 'title' => 'A Doc 2' },
        ]
      }.to_json
    }

    stub_any_rummager_search.to_return(search_results)

    results = most_popular_content.fetch
    assert_equal(results.count, 2)
  end

  test 'catches api errors' do
    Services.rummager.stubs(:search).raises(GdsApi::HTTPErrorResponse.new(500))
    results = most_popular_content.fetch

    assert_equal(results, [])
  end

  test 'starts from the first page' do
    assert_includes_params(start: 0) do
      most_popular_content.fetch
    end
  end

  test 'requests one more than wanted links' do
    assert_includes_params(count: 4) do
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
    assert_includes_params(filter_part_of_taxonomy_tree: taxon_content_ids) do
      most_popular_content.fetch
    end
  end

  test 'filters content by the requested filter_content_purpose_supergroup' do
    assert_includes_params(filter_content_purpose_supergroup: 'guidance_and_regulation') do
      most_popular_content.fetch
    end
  end

  test 'filters content by the requested filter_content_purpose_subgroups' do
    assert_includes_params(filter_content_purpose_subgroup: ['guidance']) do
      most_popular_content.fetch
    end
  end

  test 'rejects the originating page from the results' do
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
                'title' => 'How to ride a bike',
                'link' => '/how-to-ride-a-bike'
            }
        ]
    }

    Services.
      rummager.
      stubs(:search).
      returns(search_results)

    results = most_popular_content.fetch
    links = results.map { |link| link['link'] }
    refute links.include?('/how-to-ride-a-bike')
    assert links.include?('documents/1')
    assert links.include?('documents/2')
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
      with { |params| assert_includes_subhash(expected_params, params) }.
      returns(search_results)

    results = yield

    assert_equal(results.count, 2)

    assert_equal(results.first['title'], 'Doc 1')
    assert_equal(results.last['title'], 'Doc 2')
  end

  def assert_includes_subhash(expected_sub_hash, hash)
    expected_sub_hash.each do |key, value|
      assert_equal(
        value,
        hash[key],
        "Expected #{hash} to include #{key} => #{value}"
      )
    end
  end
end
