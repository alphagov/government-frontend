class MostRecentContent
  attr_reader :content_id, :current_path, :filters, :number_of_links

  def initialize(content_ids:, current_path:, filters: {}, number_of_links: 3)
    @content_ids = content_ids
    @current_path = current_path
    @filters = filters
    @number_of_links = number_of_links
  end

  def self.fetch(content_ids:, current_path:, filters:)
    new(content_ids: content_ids, current_path: current_path, filters: filters).fetch
  end

  def fetch
    search_response
  rescue GdsApi::HTTPErrorResponse => e
    GovukStatsd.increment("govuk_content_pages.most_recent.#{e.class.name.demodulize.downcase}")
    []
  end

private

  def search_response
    params = {
        start: 0,
        count: number_of_links + 1,
        fields: RummagerFields::TAXON_SEARCH_FIELDS,
        filter_part_of_taxonomy_tree: @content_ids,
        order: '-public_timestamp'
    }
    params[:filter_content_purpose_supergroup] = @filters[:filter_content_purpose_supergroup] if @filters[:filter_content_purpose_supergroup].present?
    params[:filter_content_purpose_subgroup] = @filters[:filter_content_purpose_subgroup] if @filters[:filter_content_purpose_subgroup].present?

    search_results = Services.rummager.search(params)["results"].delete_if { |result| result["link"] == current_path }[0...number_of_links]
    if search_results.count < number_of_links
      GovukStatsd.increment("govuk_content_pages.most_recent.second_rummager_query")
      params[:reject_link] = current_path
      params[:count] = number_of_links
      Services.rummager.search(params)["results"]
    else
      search_results
    end
  end
end
