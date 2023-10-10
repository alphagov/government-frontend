class AssetManagerRedirectController < ApplicationController
  def redirect_government_uploads_path
    redirect
  end

  def redirect_media_path
    redirect
  end

private

  def redirect
    asset_url = Plek.new.external_url_for("assets")
    expires_in 1.day, public: true
    redirect_to(
      { host: URI.parse(asset_url).host, status: :moved_permanently },
      allow_other_host: true,
    )
  end
end
