module WebchatProviders
  class KlickTwoContactPresenter
    def initialize(base_path)
      @base_path = base_path
    end

    def webchat_ids
      {
        "/government/organisations/hm-passport-office/contact/passport-advice-and-complaints" => 72,
      }
    end

    def webchat_id
      webchat_ids[@base_path].presence
    end

    def availability_url
      "https://hmpowebchat.klick2contact.com/v03/providers/serviceStatus/v3/#{webchat_id}.json"
    end

    def open_url
      "https://hmpowebchat.klick2contact.com/v03/providers/HMPO2/window/windowChat.html"
    end

    def config
      {
        "open-url": open_url,
        "availability-url": availability_url,
      }
    end
  end
end
