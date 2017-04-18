class TravelAdviceController < ContentItemsController

private

  def present(content_item)
    TravelAdvicePresenter.new(content_item, params[:part])
  end

  def render_template
    unless @content_item.has_valid_part?
      redirect_to @content_item.base_path
      return
    end
    super
  end

  def content_item_path
    "/foreign-travel-advice/#{URI.encode(params[:country])}"
  end
end
