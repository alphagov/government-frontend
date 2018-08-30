require 'test_helper'

class MostPopularContentTest < ActiveSupport::TestCase
  include RummagerHelpers
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

  test 'returns three results from search by default' do
    search_results = {
        body: {
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
                  'title' => 'Doc 3',
                  'link' => 'documents/3'
                },
                {
                  'title' => 'Doc 4',
                  'link' => 'documents/4'
                }
            ]
        }.to_json
    }

    stub_any_rummager_search.to_return(search_results)

    results = most_popular_content.fetch
    assert_equal(3, results.count)
  end

  test 'will use filter_link parameter if more than one results include the current path' do
    search_results_with_same_path = {
      'results' => [
        {
          'title' => 'Doc 1',
          'link' => '/how-to-ride-a-bike'
        },
        {
          'title' => 'Doc 2',
          'link' => '/how-to-ride-a-bike'
        },
        {
          'title' => 'Doc 3',
          'link' => '/how-to-ride-a-bike'
        },
        {
          'title' => 'Doc 4',
          'link' => '/how-to-ride-a-bike'
        }
      ]
    }

    search_results_without_same_path = {
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
          'title' => 'Doc 3',
          'link' => 'documents/3'
        }
      ]
    }

    parameters = {
      start: 0,
      count: 4,
      fields: RummagerFields::TAXON_SEARCH_FIELDS,
      filter_part_of_taxonomy_tree: taxon_content_ids,
      order: '-popularity',
      filter_content_purpose_supergroup: 'guidance_and_regulation',
      filter_content_purpose_subgroup: ['guidance']
    }

    Services.rummager.stubs(:search).with(parameters).returns(search_results_with_same_path)

    filtered_params = parameters.dup
    filtered_params[:reject_link] = '/how-to-ride-a-bike'
    filtered_params[:count] = 3
    Services.rummager.stubs(:search).with(filtered_params).returns(search_results_without_same_path)

    results = most_popular_content.fetch

    assert_equal(3, results.count)

    links = results.map { |result| result["link"] }
    refute links.include?("/how-to-ride-a-bike")
    1.upto(3).each do |document_id|
      assert links.include?("documents/#{document_id}")
    end
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

  test 'returns number of links plus one' do
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

    Services.rummager.stubs(:search).returns(search_results)

    results = most_popular_content.fetch
    links = results.map { |link| link['link'] }
    refute links.include?('/how-to-ride-a-bike')
    assert links.include?('documents/1')
    assert links.include?('documents/2')
  end
end
