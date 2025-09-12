Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  unless Rails.env.production?
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get "random/:schema" => "randomly_generated_content_item#show"
  end

  root to: "development#index"

  mount GovukPublishingComponents::Engine, at: "/component-guide"

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response(
    GovukHealthcheck::RailsCache,
  )

  get "/government/uploads/*path" => "asset_manager_redirect#redirect_government_uploads_path", format: false

  get "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat", to: "webchat#webchat"

  get "*path/:variant" => "content_items#show",
      constraints: {
        variant: /print/,
      }

  get "*path(.:locale)" => "content_items#show",
      constraints: {
        locale: /\w{2}(-[\d\w]{2,3})?/,
      }

  post "*path" => "content_items#service_sign_in_options"
end
