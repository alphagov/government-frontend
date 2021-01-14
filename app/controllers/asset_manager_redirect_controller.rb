class AssetManagerRedirectController < ApplicationController
  def show
    asset_url = Plek.new.asset_root
    if request.host.start_with?("draft-")
      asset_url = Plek.new.external_url_for("draft-assets")
    end

    expires_in 1.day, public: true
    redirect_to host: URI.parse(asset_url).host, status: :moved_permanently
  end
end
