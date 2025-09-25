require "slimmer/headers"

class ContentItemsController < ApplicationController
  include GovukPersonalisation::ControllerConcern
  include Slimmer::Headers
  include Slimmer::Template

  rescue_from GdsApi::HTTPForbidden, with: :error_403
  rescue_from GdsApi::HTTPNotFound, with: :error_notfound
  rescue_from GdsApi::HTTPGone, with: :error_410
  rescue_from GdsApi::InvalidUrl, with: :error_notfound
  rescue_from ActionView::MissingTemplate, with: :error_406
  rescue_from ActionController::UnknownFormat, with: :error_406
  rescue_from PresenterBuilder::RedirectRouteReturned, with: :error_redirect
  rescue_from PresenterBuilder::SpecialRouteReturned, with: :error_notfound
  rescue_from PresenterBuilder::GovernmentReturned, with: :error_notfound

  attr_accessor :content_item, :taxonomy_navigation

  content_security_policy do |p|
    p.connect_src(*p.connect_src, -> { csp_connect_src })
  end

  def show
    load_content_item

    set_expiry
    set_prometheus_labels

    set_guide_draft_access_token if @content_item.is_a?(GuidePresenter)
    render_template
  end

private

  def configure_header_search
    if @content_item.present? && !@content_item.include_search_in_header?
      remove_header_search
    end
  end

  def remove_header_search
    set_slimmer_headers(remove_search: true)
  end

  def show_error_message
    @error = true
    show
  end

  # Allow guides to pass access token to each part to allow
  # fact checking of all content
  def set_guide_draft_access_token
    @content_item.draft_access_token = params[:token]
  end

  def load_content_item
    content_item = Services.content_store.content_item(content_item_path)

    content_item["links"]["ordered_related_items"] = ordered_related_items(content_item["links"]) if content_item["links"]

    @content_item = PresenterBuilder.new(
      content_item,
      content_item_path,
      view_context,
    ).presenter
  end

  def ordered_related_items(links)
    return [] if links["ordered_related_items_overrides"].present?

    links["ordered_related_items"].presence || links.fetch(
      "suggested_ordered_related_items", []
    )
  end

  def format_banner_links(links)
    links.each.map do |(title, base_path)|
      view_context.link_to(
        title,
        base_path,
      )
    end
  end

  def content_item_template
    return "guide_single" if @content_item.render_guide_as_single_page?
    return "manual_updates" if @content_item.manual_updates?
    return "hmrc_manual_updates" if @content_item.hmrc_manual_updates?

    @content_item.schema_name
  end

  def render_template
    if @content_item.requesting_a_part? && !@content_item.has_valid_part?
      redirect_to @content_item.base_path
      return
    end

    # use this and `@content_item.base_path` in the template
    @has_govuk_account = account_session_header.present?

    request.variant = :print if params[:variant] == "print"

    respond_to do |format|
      format.html
    end

    with_locale do
      render content_item_template
    end
  end

  def set_expiry
    expires_in(
      @content_item.cache_control_max_age(request.format),
      public: @content_item.cache_control_public?,
    )
  end

  def set_prometheus_labels
    prometheus_labels = request.env.fetch("govuk.prometheus_labels", {})
    request.env["govuk.prometheus_labels"] = prometheus_labels.merge(
      document_type: @content_item.document_type,
      schema_name: @content_item.schema_name,
      graphql: use_graphql?,
    )
  end

  def with_locale(&block)
    I18n.with_locale(@content_item.locale || I18n.default_locale, &block)
  end

  def error_403(exception)
    render plain: exception.message, status: :forbidden
  end

  def error_notfound
    render plain: "Not found", status: :not_found
  end

  def error_406
    render plain: "Not acceptable", status: :not_acceptable
  end

  def error_410
    render plain: "Gone", status: :gone
  end

  def error_redirect(exception)
    destination, status_code = GdsApi::ContentStore.redirect_for_path(
      exception.content_item, request.path, request.query_string
    )
    redirect_to destination, status: status_code, allow_other_host: true
  end

  def set_account_vary_header
    # Override the default from GovukPersonalisation::ControllerConcern so pages are cached on each flash message
    # variation, rather than caching pages per user
    response.headers["Vary"] = [response.headers["Vary"], "GOVUK-Account-Session-Exists", "GOVUK-Account-Session-Flash"].compact.join(", ")
  end

  def csp_connect_src
    return if !@content_item || !@content_item.respond_to?(:csp_connect_src)

    @content_item.csp_connect_src
  end
end
