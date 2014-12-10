require 'gds_api/content_store'

class ContentItemsController < ApplicationController
  def show
    if load_content_item
      set_expiry
      set_locale
    else
      render text: 'Not found', status: :not_found
    end
  end

private

  def load_content_item
    if content_item = content_store.content_item(content_item_path)
      @content_item = ContentItemPresenter.new(content_item)
    end
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
