require 'gds_api/content_store'

class ContentItemsController < ApplicationController
  rescue_from GdsApi::HTTPForbidden, with: :error_403

  def show
    if load_content_item
      set_expiry
      set_locale
      render content_item_template
    else
      render text: 'Not found', status: :not_found
    end
  end

private

  def load_content_item
    content_item = content_store.content_item(content_item_path)
    @content_item = present(content_item) if content_item
  end

  def present(content_item)
    case content_item['format']
    when 'case_study' then CaseStudyPresenter.new(content_item)
    when 'statistics_announcement' then StatisticsAnnouncementPresenter.new(content_item)
    when 'take_part' then TakePartPresenter.new(content_item)
    when 'topical_event_about_page' then TopicalEventAboutPagePresenter.new(content_item)
    when 'unpublishing' then UnpublishingPresenter.new(content_item)
    when 'coming_soon' then ComingSoonPresenter.new(content_item)
    when 'service_manual_guide' then ServiceManualGuidePresenter.new(content_item)
    else raise "No support for format \"#{content_item['format']}\""
    end
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

  def content_item_path
    '/' + URI.encode(params[:path])
  end

  def content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.current.find("content-store"))
  end

private

  def error_403(exception)
    render text: exception.message, status: 403
  end
end
