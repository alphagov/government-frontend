Rails.application.routes.draw do
  get 'healthcheck', to: proc { [200, {}, ['']] }
  get '*path' => 'content_items#show'
end
