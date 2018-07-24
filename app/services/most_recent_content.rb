require 'gds_api/rummager'

class MostRecentContent
  include RummagerFields

  attr_reader :content_ids, :filter_content_purpose_supergroup, :number_of_links

  def initialize(content_ids:, filter_content_purpose_supergroup:, number_of_links: 5)
    @content_ids = content_ids
    @filter_content_purpose_supergroup = filter_content_purpose_supergroup
    @number_of_links = number_of_links
  end

  def self.fetch(content_ids:, filter_content_purpose_supergroup:)
    new(content_ids: content_ids, filter_content_purpose_supergroup: filter_content_purpose_supergroup).fetch
  end

  def fetch
    search_response["results"]
  end

private

  def search_response
    params = {
        start: 0,
        count: number_of_links,
        fields: RummagerFields::TAXON_SEARCH_FIELDS,
        filter_part_of_taxonomy_tree: content_ids,
        order: '-public_timestamp',
    }
    params[:filter_content_purpose_supergroup] = filter_content_purpose_supergroup if filter_content_purpose_supergroup.present?

    search_result(params)
  end

  def search_result(params)
    Services.rummager.search(params)
  end
end
