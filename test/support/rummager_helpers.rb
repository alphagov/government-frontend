module RummagerHelpers
  def stub_most_recent_content(reject_link, taxon_content_ids, content_link_count, supergroup)
    stub_for_taxon_and_supergroup(reject_link, content_link_count, taxon_content_ids, supergroup, "-public_timestamp")
  end

  def stub_most_popular_content(reject_link, taxon_content_ids, content_link_count, supergroup)
    stub_for_taxon_and_supergroup(reject_link, content_link_count, taxon_content_ids, supergroup, "-popularity")
  end

  def stub_rummager_document_without_image_url
    result = rummager_document_for_supergroup_section("doc-with-no-url", "news_story", false)
    Services.rummager.stubs(:search)
      .returns(
        "results" => [result],
        "start" => 0,
        "total" => 1
      )
  end

  def stub_for_taxon_and_supergroup(reject_link, content_link_count, content_ids, filter_content_purpose_supergroup, order_by)
    fields = %w(
      content_store_document_type
      description
      image_url
      link
      organisations
      public_timestamp
      title
    )

    params = {
      start: 0,
      count: 4,
      fields: fields,
      filter_part_of_taxonomy_tree: content_ids,
      order: order_by,
      filter_content_purpose_supergroup: filter_content_purpose_supergroup
    }

    results = generate_search_results(content_link_count, filter_content_purpose_supergroup)

    Services.rummager.stubs(:search)
      .with(params)
      .returns(
        "results" => results,
        "start" => 0,
        "total" => results.size
      )

    filtered_params = params.dup
    filtered_params[:reject_link] = reject_link
    filtered_params[:count] = 3
    Services.rummager.stubs(:search)
        .with(filtered_params)
        .returns(
          "results" => results,
          "start" => 0,
          "total" => results.size
        )
  end

  def generate_search_results(count, supergroup)
    count.times.map do |number|
      rummager_document_for_supergroup_section("content-item-#{number}", supergroup)
    end
  end

  def rummager_document_for_supergroup_section(slug, content_store_document_type, with_image_url = true)
    document = {
      'title'                       => slug.titleize.humanize.to_s,
      'link'                        => "/#{slug}",
      'description'                 => 'A description about tagged content',
      'content_store_document_type' => content_store_document_type,
      'public_timestamp'            => 1.hour.ago.iso8601,
      'organisations'               => [{ 'title' => "#{content_store_document_type.humanize} Organisation Title" }]
    }
    document['image_url'] = 'https://assets.testing.gov.uk/awesome-pic.jpg' if with_image_url
    document
  end

  def assert_includes_params(expected_params)
    search_results = {
      'results' => [
        {
            'title' => 'Doc 1'
        },
        {
            'title' => 'Doc 2'
        },
        {
            'title' => 'Doc 3'
        }
      ]
    }

    Services.
        rummager.
        stubs(:search).
        with { |params| assert_includes_subhash(expected_params, params) }.
        returns(search_results)

    results = yield

    assert_equal(results.count, 3)

    assert_equal(results.first["title"], 'Doc 1')
    assert_equal(results.last["title"], 'Doc 3')
  end
end
