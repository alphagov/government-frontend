class GonePresenter < ContentItemPresenter
  attr_reader :alternative_path, :explanation

  def initialize(content_item, requested_content_item_path = nil)
    super
    @explanation = content_item['details']['explanation']
    @alternative_path = content_item['details']['alternative_path']
  end
end
