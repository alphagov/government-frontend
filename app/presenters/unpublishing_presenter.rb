class UnpublishingPresenter < ContentItemPresenter
  attr_reader :alternative_url, :explanation

  def initialize(content_item)
    super
    @explanation = content_item['details']['explanation']
    @alternative_url = content_item['details']['alternative_url']
  end
end
