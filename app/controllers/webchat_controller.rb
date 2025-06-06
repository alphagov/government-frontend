class WebchatController < ApplicationController
  def webchat
    # TODO: avoid hardcoding this if we end up supporting more than 1 webchat on GOV.UK
    @content_item = WebchatPresenter.new(
      "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat"
    )

    render "content_items/webchat"
  end
end
