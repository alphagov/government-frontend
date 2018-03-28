class PresenterBuilder
  attr_reader :content_item, :content_item_path

  def initialize(content_item, content_item_path)
    @content_item = content_item
    @content_item_path = content_item_path
  end

  def presenter
    raise SpecialRouteReturned if special_route?
    raise RedirectRouteReturned, content_item if redirect_route?

    presenter_name.constantize.new(content_item, content_item_path)
  end

private

  def special_route?
    content_item && content_item["document_type"] == "special_route"
  end

  def redirect_route?
    content_item && content_item["schema_name"] == "redirect"
  end

  def presenter_name
    if service_sign_in_format?
      return service_sign_in_presenter_name
    end

    content_item["schema_name"].classify + "Presenter"
  end

  def service_sign_in_format?
    content_item["schema_name"] == "service_sign_in"
  end

  def service_sign_in_presenter_name
    if content_path_create_account?
      "ServiceSignIn::CreateNewAccountPresenter"
    else
      "ServiceSignIn::ChooseSignInPresenter"
    end
  end

  def content_path_create_account?
    slug = content_item_path.split("/").last
    content_item.dig("details", "create_new_account", "slug") == slug
  end

  class RedirectRouteReturned < StandardError
    attr_reader :content_item

    def initialize(content_item)
      super("Redirect content_item detected")
      @content_item = content_item
    end
  end
  class SpecialRouteReturned < StandardError; end
end
