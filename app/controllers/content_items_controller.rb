require 'gds_api/content_store'

class ContentItemsController < ApplicationController

  def show
    if @content_item = content_store.content_item(content_item_path)
      set_expiry(@content_item.expires_in)
    else
      render text: 'Not found', status: :not_found
    end
  end

  private

  def content_item_path
    '/' + URI.encode(params[:path])
  end

  def content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.current.find("content-store"))
  end
end
