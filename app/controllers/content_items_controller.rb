class ContentItemsController < ApplicationController
  class SpecialRouteReturned < StandardError; end

  include TasklistHeaderABTestable
  include TasklistABTestable
  include ContentNavigationABTestable

  rescue_from GdsApi::HTTPForbidden, with: :error_403
  rescue_from GdsApi::HTTPNotFound, with: :error_notfound
  rescue_from GdsApi::InvalidUrl, with: :error_notfound
  rescue_from ActionView::MissingTemplate, with: :error_406
  rescue_from ActionController::UnknownFormat, with: :error_406
  rescue_from SpecialRouteReturned, with: :error_notfound

  attr_accessor :content_item

  def show
    load_content_item

    setup_tasklist_header_ab_testing
    setup_tasklist_ab_testing
    set_up_traffic_signs_summary_ab_testing
    setup_content_navigation_ab_testing

    set_up_navigation
    set_expiry
    set_access_control_allow_origin_header if request.format.atom?
    set_guide_draft_access_token if @content_item.is_a?(GuidePresenter)
    render_template
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
    @content_item = present(content_item)
  end

  def special_route?(content_item)
    content_item && content_item['document_type'] == "special_route"
  end

  def present(content_item)
    presenter_name = content_item['schema_name'].classify + 'Presenter'
    presenter_class = Object.const_get(presenter_name)
    presenter_class.new(content_item, content_item_path)
  rescue NameError
    raise "No support for schema \"#{content_item['schema_name']}\""
  end

  def content_item_template
    if publication_with_sidebar?
      publication_with_sidebar_template_name
    else
      @content_item.schema_name
    end
  end

  def render_template
    if @content_item.requesting_a_part? && !@content_item.has_valid_part?
      redirect_to @content_item.base_path
      return
    end

    request.variant = :print if params[:variant] == "print"

    respond_to do |format|
      format.html
      format.atom
    end

    with_locale do
      locals = {}

      if tasklist_ab_test_applies?
        locals[:locals] = {
          tasklist: configure_current_task(TasklistContent.learn_to_drive_config)
        }
      end

      render content_item_template, locals
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
    if should_present_universal_navigation?
      request.variant = :universal_navigation
    else
      @navigation = NavigationType.new(@content_item.content_item)
      if @navigation.should_present_taxonomy_navigation?
        request.variant = :taxonomy_navigation
      end
    end
  end

  def with_locale
    I18n.with_locale(@content_item.locale || I18n.default_locale) { yield }
  end

  def setup_tasklist_header_ab_testing
    set_tasklist_header_response_header
  end

  def setup_tasklist_ab_testing
    set_tasklist_response_header
  end

  def setup_content_navigation_ab_testing
    set_content_navigation_response_header
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
end
