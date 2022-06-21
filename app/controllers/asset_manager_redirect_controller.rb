class AssetManagerRedirectController < ApplicationController
  def show
    asset_url = Plek.new.external_url_for("assets")
    expires_in 1.day, public: true
    redirect_to host: URI.parse(asset_url).host, status: :moved_permanently
  end
end
