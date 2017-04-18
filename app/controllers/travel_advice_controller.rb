class TravelAdviceController < ContentItemsController
  after_action :set_access_control_allow_origin_header,
    only: :show, if: ->(controller) { controller.request.format.atom? }

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

  def set_access_control_allow_origin_header
    response.headers["Access-Control-Allow-Origin"] = "*"
  end
end
