class MostRecentContent
  attr_reader :content_id, :current_path, :filters, :number_of_links

  def initialize(content_ids:, current_path:, filter_content_purpose_supergroup:, number_of_links: 3)
    @content_ids = content_ids
    @current_path = current_path
    @filters = filters
    @number_of_links = number_of_links
  end

  def self.fetch(content_ids:, current_path:, filters:)
    new(content_ids: content_ids, current_path: current_path, filters: filters).fetch
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
        order: '-public_timestamp',
        reject_link: current_path,
    }
    params[:filter_content_purpose_supergroup] = @filters[:filter_content_purpose_supergroup] if @filters[:filter_content_purpose_supergroup].present?
    params[:filter_content_purpose_subgroup] = @filters[:filter_content_purpose_subgroup] if @filters[:filter_content_purpose_subgroup].present?

    Services.rummager.search(params)
  end
end
