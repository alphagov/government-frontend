class ContentItemsController < ApplicationController
  class RedirectRouteReturned < StandardError
    attr_reader :content_item

    def initialize(content_item)
      super("Redirect content_item detected")
      @content_item = content_item
    end
  end
  class SpecialRouteReturned < StandardError; end
  rescue_from GdsApi::HTTPForbidden, with: :error_403
  rescue_from GdsApi::HTTPNotFound, with: :error_notfound
  rescue_from GdsApi::HTTPGone, with: :error_410
  rescue_from GdsApi::InvalidUrl, with: :error_notfound
  rescue_from ActionView::MissingTemplate, with: :error_406
  rescue_from ActionController::UnknownFormat, with: :error_406
  rescue_from RedirectRouteReturned, with: :error_redirect
  rescue_from SpecialRouteReturned, with: :error_notfound

  attr_accessor :content_item

  def show
    load_content_item

    set_up_navigation
    set_expiry
    set_access_control_allow_origin_header if request.format.atom?
    set_guide_draft_access_token if @content_item.is_a?(GuidePresenter)
    render_template
  end

  def service_sign_in_options
    if params[:option].blank?
      @error = true
      show
    else
      load_content_item
      selected = @content_item.selected_option(params[:option])
      redirect_to selected[:url]
    end
  end

private

  # Allow guides to pass access token to each part to allow
  # fact checking of all content
  def set_guide_draft_access_token
    @content_item.draft_access_token = params[:token]
  end

  def load_content_item
    content_item = Services.content_store.content_item(content_item_path)
    raise SpecialRouteReturned if special_route?(content_item)
    raise RedirectRouteReturned, content_item if redirect_route?(content_item)
    @content_item = present(content_item)
  end

  def special_route?(content_item)
    content_item && content_item["document_type"] == "special_route"
  end

  def redirect_route?(content_item)
    content_item && content_item["schema_name"] == "redirect"
  end

  def present(content_item)
    presenter_name = presenter_name(content_item)
    presenter_class = Object.const_get(presenter_name)
    presenter_class.new(content_item, content_item_path)
  rescue NameError
    raise "No support for schema \"#{content_item['schema_name']}\""
  end

  def content_item_template
    @content_item.schema_name
  end

  def render_template
    if @content_item.requesting_a_part? && !@content_item.has_valid_part?
      redirect_to @content_item.base_path
      return
    end

    if @content_item.requesting_a_service_sign_in_page? && !@content_item.has_valid_path?
      redirect_to @content_item.path
      return
    end

    request.variant = :print if params[:variant] == "print"

    respond_to do |format|
      format.html
      format.atom
    end

    with_locale do
      render content_item_template
    end
  end

  def set_access_control_allow_origin_header
    response.headers["Access-Control-Allow-Origin"] = "*"
  end

  def set_expiry
    max_age = @content_item.content_item.cache_control.max_age
    cache_private = @content_item.content_item.cache_control.private?
    expires_in(max_age, public: !cache_private)
  end

  def set_up_navigation
    # Setting a variant on a request is a type of Rails Dark Magic that will
    # use a convention to automagically load an alternative partial, view or
    # layout.  For example, if I set a variant of :taxonomy_navigation and we render
    # a partial called _breadcrumbs.html.erb then Rails will attempt to load
    # _breadcrumbs.html+taxonomy_navigation.erb instead. If this file doesn't exist,
    # then it falls back to _breadcrumbs.html.erb.  See:
    # http://edgeguides.rubyonrails.org/4_1_release_notes.html#action-pack-variants
    @navigation = NavigationType.new(@content_item.content_item)
    if @navigation.should_present_taxonomy_navigation?
      request.variant = :taxonomy_navigation
    end
  end

  def with_locale
    I18n.with_locale(@content_item.locale || I18n.default_locale) { yield }
  end

  def presenter_name(content_item)
    if service_sign_in_format?(content_item["schema_name"])
      return service_sign_in_presenter_name(content_item)
    end

    content_item['schema_name'].classify + 'Presenter'
  end

  def service_sign_in_format?(schema_name)
    schema_name == "service_sign_in"
  end

  def service_sign_in_presenter_name(content_item)
    slug = content_item_path.split("/").last

    if content_item.dig("details", "create_new_account", "slug") == slug
      return "ServiceSignIn::CreateNewAccountPresenter"
    end

    "ServiceSignIn::ChooseSignInPresenter"
  end

  def error_403(exception)
    render plain: exception.message, status: 403
  end

  def error_notfound
    render plain: 'Not found', status: :not_found
  end

  def error_406
    render plain: 'Not acceptable', status: 406
  end

  def error_410
    render plain: 'Gone', status: 410
  end

  def error_redirect(exception)
    destination, status_code = GdsApi::ContentStore.redirect_for_path(
      exception.content_item, request.path, request.query_string
    )
    redirect_to destination, status: status_code
  end
end
