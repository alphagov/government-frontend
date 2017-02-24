Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  with_options format: false do |r|
    r.get 'healthcheck', to: proc { [200, {}, ['']] }
    # FIXME: Update when https://trello.com/c/w8HN3M4A/ is ready
    r.get 'foreign-travel-advice/:country/:part' => 'travel_advice#show'
    r.get '*path' => 'content_items#show', constraints: { path: %r[.*] }
  end
end
