namespace :publishing_api do
  desc "Publish static pages"
  task publish_static_pages: [:environment] do
    PublishStaticPages.publish_all
  end
end
