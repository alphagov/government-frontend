Rails.application.routes.draw do
  unless Rails.env.production?
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
    get 'random/:schema' => 'randomly_generated_content_item#show'
  end

  mount GovukPublishingComponents::Engine, at: "/component-guide" if defined?(GovukPublishingComponents)

  get 'healthcheck', to: proc { [200, {}, ['']] }
  get '*path/choose-sign-in', to: 'content_items#choose_sign_in'
  get '*path/not-registered', to: 'content_items#not_registered'
  get '*path/lost-account-details', to: 'content_items#lost_account_details'

  get '*path/:variant' => 'content_items#show',
      constraints: {
        variant: /print/
      }

  get '*path(.:locale)(.:format)' => 'content_items#show',
      constraints: {
        format: /atom/,
        locale: /\w{2}(-[\d\w]{2,3})?/,
      }
end
