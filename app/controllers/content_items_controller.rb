require 'gds_api/content_store'

class ContentItemsController < ApplicationController
  before_action :load_content_item
  before_action :set_locale

  def show
  end

private

  def load_content_item
    if content_item = content_store.content_item(content_item_path)
      set_expiry(content_item.expires_in)
      @content_item = ContentItemPresenter.new(content_item)
    else
      render text: 'Not found', status: :not_found
    end
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
