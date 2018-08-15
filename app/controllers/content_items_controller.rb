class ContentItemsController < ApplicationController
  include ContentPagesNavAbTestable

  rescue_from GdsApi::HTTPForbidden, with: :error_403
  rescue_from GdsApi::HTTPNotFound, with: :error_notfound
  rescue_from GdsApi::HTTPGone, with: :error_410
  rescue_from GdsApi::InvalidUrl, with: :error_notfound
  rescue_from ActionView::MissingTemplate, with: :error_406
  rescue_from ActionController::UnknownFormat, with: :error_406
  rescue_from PresenterBuilder::RedirectRouteReturned, with: :error_redirect
  rescue_from PresenterBuilder::SpecialRouteReturned, with: :error_notfound

  attr_accessor :content_item, :taxonomy_navigation

  def show
    load_content_item

    load_taxonomy_navigation if show_new_navigation?

    set_expiry
    set_access_control_allow_origin_header if request.format.atom?
    set_guide_draft_access_token if @content_item.is_a?(GuidePresenter)
    render_template
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

      redirect_to selected[:url]
    end
  end

private

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
    @content_item = PresenterBuilder.new(content_item, content_item_path).presenter
    @content_item.include_collections_in_other_publisher_metadata = show_new_navigation?
  end

  def load_taxonomy_navigation
    if @content_item.taxons.present?
      current_base_path = @content_item.base_path
      taxons = @content_item.taxons.select { |taxon| taxon["phase"] == "live" }
      taxon_ids = taxons.map { |taxon| taxon["content_id"] }

      @taxonomy_navigation = {}
      @content_item.links_out_supergroups.each do |supergroup|
        supergroup_taxon_links = "Supergroups::#{supergroup.camelcase}".constantize.new(current_base_path, taxon_ids, filter_content_purpose_subgroup: @content_item.links_out_subgroups)
        @taxonomy_navigation[supergroup.to_sym] = supergroup_taxon_links.tagged_content
      end

      @tagged_taxons = taxons.map do |taxon|
        {
          taxon_id: taxon["content_id"],
          taxon_name: taxon["title"],
          taxon_link: taxon["base_path"],
        }
      end

      @related_collections = @content_item
                               .content_item
                               .dig('links', 'document_collections')
                               .yield_self { |document_collections| document_collections || [] }
                               .select { |document_collection| document_collection['document_type'] == 'document_collection' }
                               .map { |document_collection| document_collection.values_at('base_path', 'title') }

      # Fetch link attributes of parent step by steps required to render the top navigation banner
      step_by_step_links = @content_item
                        .content_item
                        .dig('links', 'part_of_step_navs')
                        .yield_self { |part_of_step_navs| part_of_step_navs || [] }
                        .sort_by { |step_by_step_nav| step_by_step_nav['title'] }
                        .map { |step_by_step_nav| step_by_step_nav.values_at('title', 'base_path') }
      @banner_items = format_banner_links(step_by_step_links, "Step by Step")

      # Append link attributes of parent taxons to our collections of items for the top navigation banner if the
      # content item is tagged to more than one taxon. If there is only one taxon a breadcrumb will be used instead.
      if taxons.many?
        taxon_links = taxons
                           .sort_by { |taxon| taxon[:taxon_name] }
                           .map { |taxon| taxon.values_at('title', 'base_path') }
        @banner_items += format_banner_links(taxon_links, "Taxon")
      end
    end
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
            dimension29: title
          }
        }
      )
    end
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
    expires_in(@content_item.cache_control_max_age(request.format),
               public: @content_item.cache_control_public?)
  end

  def with_locale
    I18n.with_locale(@content_item.locale || I18n.default_locale) { yield }
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
