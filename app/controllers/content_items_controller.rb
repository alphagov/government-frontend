class ContentItemsController < ApplicationController
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

  def show
    load_content_item

    set_expiry

    if is_history_page?
      show_history_page
    else
      set_use_recommended_related_links_header
      set_access_control_allow_origin_header if request.format.atom?
      set_guide_draft_access_token if @content_item.is_a?(GuidePresenter)
      render_template
    end
  end

  def service_sign_in_options
    return head :not_found unless is_sign_in_content_item_path?

    if params[:option].blank?
      show_error_message
    else
      load_content_item
      selected = @content_item.selected_option(params[:option])

      if selected.nil?
        show_error_message
        return
      end

      redirect_to service_url(selected[:url])
    end
  end

private

  def is_history_page?
    @content_item.document_type == "history"
  end

  def show_history_page
    page_id = content_item_path.split("/").last.underscore
    valid_page_ids = %w[
      10_downing_street
      11_downing_street
      1_horse_guards_road
      king_charles_street
      lancaster_house
      history
    ]

    if valid_page_ids.include?(page_id)
      @do_not_show_breadcrumbs = true

      render template: "histories/#{page_id}"
    else
      render plain: "Not found", status: :not_found
    end
  end

  def show_error_message
    @error = true
    show
  end

  def is_sign_in_content_item_path?
    content_item_path.include?("sign-in")
  end

  # Allow guides to pass access token to each part to allow
  # fact checking of all content
  def set_guide_draft_access_token
    @content_item.draft_access_token = params[:token]
  end

  def load_content_item
    content_item = Services.content_store.content_item(content_item_path)

    if Services.feature_toggler.use_recommended_related_links?(content_item["links"], request.headers)
      content_item["links"]["ordered_related_items"] = content_item["links"].fetch("suggested_ordered_related_items", [])
    end

    @content_item = PresenterBuilder.new(
      content_item,
      content_item_path,
      view_context,
    ).presenter
  end

  def format_banner_links(links, type)
    links.each.with_index(1).map do |(title, base_path), index|
      view_context.link_to(
        title,
        base_path,
        data: {
          "track-category": "relatedTaxonomyLinkClicked",
          "track-action": "1.#{index} #{type}",
          "track-label": base_path,
          "track-options": {
            dimension29: title,
          },
        },
      )
    end
  end

  def content_item_template
    return "briefing" if is_briefing?

    @content_item.schema_name
  end

  def is_briefing?
    @content_item.content_id == "3d66e959-72d2-417d-89c1-00cd72eea30f"
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

  def set_use_recommended_related_links_header
    response.headers["Vary"] = [response.headers["Vary"], FeatureFlagNames.recommended_related_links].compact.join(", ")

    related_links_request_header = RequestHelper.get_header(FeatureFlagNames.recommended_related_links, request.headers)
    required_header_value = Services.feature_toggler.feature_flags.get_feature_flag(FeatureFlagNames.recommended_related_links)
    response.headers[FeatureFlagNames.recommended_related_links] = (related_links_request_header == required_header_value).to_s
  end

  def set_expiry
    expires_in(
      @content_item.cache_control_max_age(request.format),
      public: @content_item.cache_control_public?,
    )
  end

  def service_url(original_url)
    ga_param = params[:_ga]
    return original_url if ga_param.nil?

    url = URI.parse(original_url)
    new_query_ar = URI.decode_www_form(url.query || "") << ["_ga", ga_param]
    url.query = URI.encode_www_form(new_query_ar)
    url.to_s
  end

  def with_locale
    I18n.with_locale(@content_item.locale || I18n.default_locale) { yield }
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
    redirect_to destination, status: status_code
  end
end
