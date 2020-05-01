class GonePresenter < ContentItemPresenter
  attr_reader :alternative_path, :explanation

  def initialize(*args)
    super
    @explanation = content_item["details"]["explanation"]
    @alternative_path = content_item["details"]["alternative_path"]
  end

  def page_title
    "No longer available"
  end
end
