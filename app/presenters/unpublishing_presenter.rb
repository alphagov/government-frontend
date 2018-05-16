class UnpublishingPresenter < ContentItemPresenter
  attr_reader :alternative_url, :explanation

  def initialize(content_item, requested_content_item_path = nil)
    super
    @explanation = content_item['details']['explanation']
    @alternative_url = content_item['details']['alternative_url']
  end

  def page_title
    "No longer available"
  end

  # Unpublishing pages do not need a schem because they're not useful to search engines
  def structured_data
    {}
  end
end
