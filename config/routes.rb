Rails.application.routes.draw do
  unless Rails.env.production?
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
    get 'random/:schema' => 'randomly_generated_content_item#show'
  end

  root to: 'development#index'

  mount GovukPublishingComponents::Engine, at: "/component-guide" if defined?(GovukPublishingComponents)

  get 'healthcheck', to: proc { [200, {}, ['']] }

  get '*path/:variant' => 'content_items#show',
      constraints: {
        variant: /print/
      }

  get '*path(.:locale)(.:format)' => 'content_items#show',
      constraints: {
        format: /atom/,
        locale: /\w{2}(-[\d\w]{2,3})?/,
      }

  post '*path' => 'content_items#service_sign_in_options'
end
