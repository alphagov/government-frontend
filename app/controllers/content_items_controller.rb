require 'gds_api/content_store'

class ContentItemsController < ApplicationController
  attr_accessor :content_item

  def show
    load_content_item
    set_up_education_navigation_ab_testing
    set_expiry
    render_template
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

  def render_template
    request.variant = :print if params[:variant] == "print"

    with_locale do
      render content_item_template
    end
  end

  def set_expiry
    max_age = @content_item.content_item.cache_control.max_age
    cache_private = @content_item.content_item.cache_control.private?
    expires_in(max_age, public: !cache_private)
  end

  def set_up_education_navigation_ab_testing
    @education_navigation_ab_test = EducationNavigationAbTestRequest.new(
      request, @content_item.content_item
    )
    return unless @education_navigation_ab_test.ab_test_applies?

    @education_navigation_ab_test.set_response_vary_header response

    # Setting a variant on a request is a type of Rails Dark Magic that will
    # use a convention to automagically load an alternative partial, view or
    # layout.  For example, if I set a variant of :new_navigation and we render
    # a partial called _breadcrumbs.html.erb then Rails will attempt to load
    # _breadcrumbs.html+new_navigation.erb instead. If this file doesn't exist,
    # then it falls back to _breadcrumbs.html.erb.  See:
    # http://edgeguides.rubyonrails.org/4_1_release_notes.html#action-pack-variants
    if @education_navigation_ab_test.should_present_new_navigation_view?
      request.variant = :new_navigation
    end
  end

  def with_locale
    yield
    # I18n.with_locale(@content_item.locale || I18n.default_locale) { yield }
  end

  def content_item_path
    path_and_optional_locale = params
                                 .values_at(:path, :locale)
                                 .compact
                                 .join('.')

    '/' + URI.encode(path_and_optional_locale)
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

  def error_406
    render plain: 'Not acceptable', status: 406
  end
end
