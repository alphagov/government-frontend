class PresenterBuilder
  attr_reader :content_item, :content_item_path, :view_context

  def initialize(content_item, content_item_path, view_context)
    @content_item = content_item
    @content_item_path = content_item_path
    @view_context = view_context
  end

  def presenter
    raise SpecialRouteReturned if special_route?
    raise RedirectRouteReturned, content_item if redirect_route?
    raise GovernmentReturned if government_content_item?

    presenter_name.constantize.new(
      content_item,
      content_item_path,
      view_context,
    )
  end

private

  def special_route?
    content_item && content_item["document_type"] == "special_route"
  end

  def redirect_route?
    content_item && content_item["schema_name"] == "redirect"
  end

  def government_content_item?
    content_item && content_item["document_type"] == "government"
  end

  def presenter_name
    return service_sign_in_presenter_name if service_sign_in_format?
    return "ManualUpdatesPresenter" if manual_updates?
    return "HmrcManualUpdatesPresenter" if hmrc_manual_updates?
    return "WorldwideOrganisationOfficePresenter" if worldwide_organisation_office?
    return "WorldwideOrganisationPagePresenter" if worldwide_organisation_page?

    "#{content_item['schema_name'].classify}Presenter"
  end

  def manual_updates?
    view_context.request.path =~ /^\/guidance\/.*\/updates$/ && content_item["schema_name"] == "manual"
  end

  def hmrc_manual_updates?
    view_context.request.path =~ /^\/hmrc-internal-manuals\/.*\/updates$/ && content_item["schema_name"] == "hmrc_manual"
  end

  def worldwide_organisation_office?
    view_context.request.path =~ /^\/world\/.*\/office\/.*$/ && content_item["schema_name"] == "worldwide_organisation"
  end

  def worldwide_organisation_page?
    view_context.request.path =~ /^\/world\/.*\/about\/.*$/ && content_item["schema_name"] == "worldwide_organisation"
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

  class GovernmentReturned < StandardError; end
end
