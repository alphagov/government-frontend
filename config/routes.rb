Rails.application.routes.draw do
  unless Rails.env.production?
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
    get 'random/:schema' => 'randomly_generated_content_item#show'
  end

  get 'healthcheck', to: proc { [200, {}, ['']] }
  get '*path/:variant' => 'content_items#show',
      constraints: {
        variant: /print/
      }

  # FIXME: Update when https://trello.com/c/w8HN3M4A/ is ready
  get 'foreign-travel-advice/:country/:part' => 'travel_advice#show'

  get '*path(.:locale)(.:format)' => 'content_items#show',
      constraints: {
        format: /atom/,
        locale: /\w{2}(-[\d\w]{2,3})?/,
      }
end
