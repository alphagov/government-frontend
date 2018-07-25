class GuidanceAndRegulation < Supergroup
  def initialize(content_item)
    super(content_item, "guidance_and_regulation")
  end

private

  def content_class
    MostPopularContent
  end
end
