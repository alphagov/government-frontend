Rails.application.routes.draw do
  root to: "development#index"

  mount GovukPublishingComponents::Engine, at: "/component-guide"

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response(
    GovukHealthcheck::RailsCache,
    GovukHealthcheck::EmergencyBannerRedis,
  )

  get "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat", to: "webchat#webchat"

  get "*path(.:locale)" => "content_items#show",
      constraints: {
        locale: /\w{2}(-[\d\w]{2,3})?/,
      }
end
