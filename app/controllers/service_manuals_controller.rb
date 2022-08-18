require "gds_api/content_store"
require "slimmer/headers"

class ServiceManualsController < ContentItemsController
  include Slimmer::Headers
  include Slimmer::Template
  rescue_from GdsApi::HTTPForbidden, with: :error_403

  attr_accessor :content_item

  def show
    slimmer_template layout

    if load_content_item
      set_expiry
      set_locale
      configure_header_search
      render content_item_template
    else
      configure_header_search
      render body: "Not found", status: :not_found
    end
  end

private

  def layout
    paths = %w[service-manual service-toolkit]
    paths.include?(params[:path]) ? "gem_layout_full_width_no_footer_navigation" : "gem_layout_no_footer_navigation"
  end

  def load_content_item
    @content_item = present(
      content_store.content_item(content_item_path),
    )
  rescue GdsApi::HTTPNotFound
    nil
  end

  def present(content_item)
    unsupported_message = <<~ERROR
      The content item at base path #{content_item['base_path']} is of
      document_type \"#{content_item['document_type']}\", which this
      application does not support.
    ERROR

    raise unsupported_message unless content_item["document_type"].starts_with?("service_manual_")

    class_name = content_item["document_type"].delete_prefix("service_manual_").classify
    presenter_name = "#{class_name}Presenter"
    presenter_class = Object.const_get(presenter_name)
    presenter_class.new(content_item)
  rescue NameError
    raise unsupported_message
  end

  def content_item_template
    @content_item.format
  end

  def set_expiry
    max_age = @content_item.content_item.cache_control.max_age
    cache_private = @content_item.content_item.cache_control.private?
    expires_in(max_age, public: !cache_private)
  end

  def set_locale
    I18n.locale = @content_item.locale || I18n.default_locale
  end

  #def content_item_path
  #  "/#{params[:path]}"
  #end

  def content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.current.find("content-store"))
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

  def error_403(exception)
    render body: exception.message, status: :forbidden
  end
end
