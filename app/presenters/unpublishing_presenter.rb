class UnpublishingPresenter
  attr_reader :alternative_url, :content_item, :explanation, :format, :locale

  def initialize(content_item)
    @content_item = content_item

    @format = content_item['format']
    @locale = content_item['locale']
    @explanation = content_item['details']['explanation']
    @alternative_url = content_item['details']['alternative_url']
  end
end
