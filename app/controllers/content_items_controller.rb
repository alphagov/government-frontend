require 'gds_api/content_store'

class ContentItemsController < ApplicationController
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
    if content_item = content_store.content_item(content_item_path)
      @content_item = present(content_item)
    end
  end

  def present(content_item)
    case content_item['format']
      when 'case_study' then ContentItemPresenter.new(content_item)
      when 'unpublishing' then UnpublishingPresenter.new(content_item)
      else raise "No support for format \"#{content_item['format']}\""
    end
  end

  def content_item_template
    @content_item.format
  end

  def set_expiry
    super(@content_item.content_item.expires_in)
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
end
