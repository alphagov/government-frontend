require 'test_helper'

class MostRecentContentTest < ActiveSupport::TestCase
  include RummagerFields
  include GdsApi::TestHelpers::Rummager

  def most_recent_content
    @most_recent_content ||= MostRecentContent.new(
      content_ids: taxon_content_ids,
      filter_content_purpose_supergroup: 'news_and_communications',
    )
  end

  def taxon_content_ids
    ['some-id', 'some-other-id']
  end

  test 'returns the results from search' do
    search_results = {
        body: {
            'results' => [
                { 'title' => 'First news story' },
                { 'title' => 'Second news story' },
                { 'title' => 'Third news story' },
                { 'title' => 'Fourth news story' },
                { 'title' => 'Fifth news story' }
            ]
        }.to_json
    }

    stub_any_rummager_search.to_return(search_results)

    results = most_recent_content.fetch
    assert_equal(results.count, 5)
  end

  test 'starts from the first page' do
    assert_includes_params(start: 0) do
      most_recent_content.fetch
    end
  end

  test 'requests five results by default' do
    assert_includes_params(count: 5) do
      most_recent_content.fetch
    end
  end

  test 'requests a limited number of fields' do
    fields = RummagerFields::TAXON_SEARCH_FIELDS

    assert_includes_params(fields: fields) do
      most_recent_content.fetch
    end
  end

  test 'orders the results by public_timestamp in descending order' do
    assert_includes_params(order: '-public_timestamp') do
      most_recent_content.fetch
    end
  end

  test 'scopes the results to the current taxon' do
    assert_includes_params(filter_part_of_taxonomy_tree: taxon_content_ids) do
      most_recent_content.fetch
    end
  end

  test 'filters content by the requested filter_content_purpose_supergroup only' do
    assert_includes_params(filter_content_purpose_supergroup: 'news_and_communications') do
      most_recent_content.fetch
    end
  end

  def assert_includes_params(expected_params)
    search_results = {
        'results' => [
            { 'title' => 'First news story' },
            { 'title' => 'Second news story' },
            { 'title' => 'Third news story' },
            { 'title' => 'Fourth news story' },
            { 'title' => 'Fifth news story' }
        ]
    }

    Services.
        rummager.
        stubs(:search).
        with { |params| assert_includes_subhash(expected_params, params) }.
        returns(search_results)

    results = yield

    assert_equal(results.count, 5)

    assert_equal(results.first['title'], 'First news story')
    assert_equal(results.last['title'], 'Fifth news story')
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
