class MostPopularContent
  attr_reader :content_id, :filter_taxon, :number_of_links

  def initialize(content_ids:, filter_content_purpose_supergroup:, number_of_links: 6)
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
        fields: %w(title
                   link
                   description
                   content_store_document_type
                   public_timestamp
                   organisations),
        filter_part_of_taxonomy_tree: @content_ids,
        order: '-popularity',
    }
    params[:filter_content_purpose_supergroup] = @filter_content_purpose_supergroup if @filter_content_purpose_supergroup.present?
    Services.rummager.search(params)
  end
end
