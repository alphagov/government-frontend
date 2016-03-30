Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  with_options format: false do |r|
    r.get 'healthcheck', to: proc { [200, {}, ['']] }
    r.get '*path' => 'content_items#show', constraints: { path: %r[.*] }
  end
end
