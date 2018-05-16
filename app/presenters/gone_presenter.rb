class GonePresenter < ContentItemPresenter
  attr_reader :alternative_path, :explanation

  def initialize(content_item, requested_content_item_path = nil)
    super
    @explanation = content_item['details']['explanation']
    @alternative_path = content_item['details']['alternative_path']
  end

  def page_title
    "No longer available"
  end

  # Gone pages do not need a schem because they're not useful to search engines
  def structured_data
    {}
  end
end
