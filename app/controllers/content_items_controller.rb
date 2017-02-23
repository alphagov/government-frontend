require 'gds_api/content_store'

class ContentItemsController < ApplicationController
  rescue_from GdsApi::HTTPForbidden, with: :error_403
  rescue_from GdsApi::HTTPNotFound, with: :error_notfound

  attr_accessor :content_item

  def show
    load_content_item
    set_up_education_navigation_ab_testing
    set_expiry
    with_locale do
      render content_item_template
    end
  end

private

  def load_content_item
    content_item = content_store.content_item(content_item_path)
    @content_item = present(content_item)
  end

  def present(content_item)
    presenter_name = content_item['schema_name'].classify + 'Presenter'
    presenter_class = Object.const_get(presenter_name)
    presenter_class.new(content_item)
  rescue NameError
    raise "No support for schema \"#{content_item['schema_name']}\""
  end

  def content_item_template
    @content_item.format
  end

  def set_expiry
    max_age = @content_item.content_item.cache_control.max_age
    cache_private = @content_item.content_item.cache_control.private?
    expires_in(max_age, public: !cache_private)
  end

  def set_up_education_navigation_ab_testing
    @education_navigation_ab_test = EducationNavigationAbTestRequest.new(request, @content_item.content_item)
    return unless @education_navigation_ab_test.ab_test_applies?

    @education_navigation_ab_test.set_response_vary_header response

    # Setting a variant on a request is a type of Rails Dark Magic that will use a convention to automagically load
    # an alternative partial/view/layout.
    # For example, if I set a variant of :new_navigation and we render a partial called _breadcrumbs.html.erb then Rails
    # will attempt to load _breadcrumbs.html+new_navigation.erb instead. If such a file does not exist, then it falls
    # back to _breadcrumbs.html.erb.
    # See: http://edgeguides.rubyonrails.org/4_1_release_notes.html#action-pack-variants
    request.variant = :new_navigation if @education_navigation_ab_test.should_present_new_navigation_view?
  end

  def with_locale
    I18n.with_locale(@content_item.locale || I18n.default_locale) { yield }
  end

  def content_item_path
    '/' + URI.encode(params[:path])
  end

  def content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.current.find("content-store"))
  end

  def error_403(exception)
    render plain: exception.message, status: 403
  end

  def error_notfound
    render plain: 'Not found', status: :not_found
  end
end
