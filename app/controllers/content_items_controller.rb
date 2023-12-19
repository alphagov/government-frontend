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

    temporary_ab_test_find_utr_page
    temporary_ab_test_stop_self_employed
    set_expiry

    if is_service_manual?
      show_service_manual_page
    elsif is_history_page?
      show_history_page
    else
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

      redirect_to service_url(selected[:url]), allow_other_host: true
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
      render template: "histories/#{page_id}"
    else
      render plain: "Not found", status: :not_found
    end
  end

  def is_service_manual?
    @content_item.document_type.include?("service_manual")
  end

  def show_service_manual_page
    slimmer_template(service_manual_layout)
    configure_header_search

    with_locale do
      render content_item_template
    end
  end

  def service_manual_layout
    types = %w[service_manual_homepage service_manual_service_toolkit]
    types.include?(@content_item.document_type) ? "gem_layout_full_width_no_footer_navigation" : "gem_layout_no_footer_navigation"
  end

  def configure_header_search
    if @content_item.present? && !@content_item.include_search_in_header?
      remove_header_search
    else
      scope_header_search_to_service_manual
    end
  end

  def scope_header_search_to_service_manual
    # Slimmer is middleware which wraps the service manual in the GOV.UK header
    # and footer. We set a response header so that Slimmer adds a hidden field
    # to the header search to scope the search results to just the service
    # manual.
    set_slimmer_headers(
      search_parameters: {
        "filter_manual" => "/service-manual",
      }.to_json,
    )
  end

  def remove_header_search
    set_slimmer_headers(remove_search: true)
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

    if @content_item.requesting_a_service_sign_in_page? && !@content_item.has_valid_path?
      redirect_to @content_item.path
      return
    end

    # use this and `@content_item.base_path` in the template
    @has_govuk_account = account_session_header.present?

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

  # TEMPORARY (author: richard.towers, expected end date: February 2024)
  # Content specific AB test for the Find your UTR number page
  def temporary_ab_test_find_utr_page
    placeholder = "{{ab_test_find_utr_number_video_links}}"
    if @content_item.base_path == "/find-utr-number" && @content_item.body.include?(placeholder)
      ab_test = GovukAbTesting::AbTest.new(
        "FindUtrNumberVideoLinks",
        dimension: 61, # https://docs.google.com/spreadsheets/d/1h4vGXzIbhOWwUzourPLIc8WM-iU1b6WYOVDOZxmU1Uo/edit#gid=254065189&range=69:69
        allowed_variants: %w[A B Z],
        control_variant: "Z",
      )
      @requested_variant = ab_test.requested_variant(request.headers)
      @requested_variant.configure_response(response)

      replacement = case @requested_variant.variant_name
                    when "A"
                      I18n.t("ab_tests.find_utr_number_video_links.A")
                    when "B"
                      I18n.t("ab_tests.find_utr_number_video_links.B")
                    else
                      I18n.t("ab_tests.find_utr_number_video_links.Z")
                    end
      @content_item.body.sub!(placeholder, replacement)
    end
  end
  # /TEMPORARY


  def temporary_ab_test_stop_self_employed
    placeholder = "{{ab_test_sa_video_stop_self_employed}}"
    if @content_item.base_path == "/stop-being-self-employed" && @content_item.body.include?(placeholder)
      ab_test = GovukAbTesting::AbTest.new(
        "SAVideoStopSelfEmployed",
        dimension: 47, # https://docs.google.com/spreadsheets/d/1h4vGXzIbhOWwUzourPLIc8WM-iU1b6WYOVDOZxmU1Uo/edit#gid=254065189&range=69:69
        allowed_variants: %w[A B Z],
        control_variant: "Z",
        )
      @requested_variant = ab_test.requested_variant(request.headers)
      @requested_variant.configure_response(response)

      replacement = case @requested_variant.variant_name
                    when "A"
                      I18n.t("ab_tests.sa_video_stop_self_employed.A")
                    when "B"
                      I18n.t("ab_tests.sa_video_stop_self_employed.B")
                    else
                      I18n.t("ab_tests.sa_video_stop_self_employed.Z")
                    end
      @content_item.body.sub!(placeholder, replacement)
    end
  end
  # /TEMPORARY
end
