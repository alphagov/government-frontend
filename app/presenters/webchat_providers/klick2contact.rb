module WebchatProviders
  module Klick2Contact
    def webchat_ids
      {
        "/government/organisations/hm-passport-office/contact/passport-advice-and-complaints" => 72,
      }
    end

    def webchat_availability_url
      "https://hmpowebchat.klick2contact.com/v03/providers/serviceStatus/v3/#{webchat_id}.json"
    end

    def webchat_open_url
      "https://hmpowebchat.klick2contact.com/v03/providers/HMPO2/window/windowChat.html"
    end

    def webchat_provider
      webchat_provider_id.to_s
    end

    def webchat_provider_config
      {
        "chat-provider": webchat_provider,
        "open-url": webchat_open_url,
        "availability-url": webchat_availability_url,
      }
    end
  end
end
