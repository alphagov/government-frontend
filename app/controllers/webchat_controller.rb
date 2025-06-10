class WebchatController < ApplicationController
  def webchat
    @content_item = WebchatPresenter.new("/government/organisations/hm-passport-office/contact/hm-passport-office-webchat")
    render "content_items/webchat"
  end

  content_security_policy do |p|
    p.connect_src(*p.connect_src, -> { @content_item.csp_connect_src })
  end
end
