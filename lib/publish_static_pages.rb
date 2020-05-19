module PublishStaticPages
  PAGES = [
    {
      content_id: "14aa298f-03a8-4e76-96de-483efa3d001f",
      title: "History of 10 Downing Street",
      description: "10 Downing Street, the locale of British prime ministers since 1735, vies with the White House as being the most important political building anywhere in the world in the modern era.",
      template: "histories/10_downing_street",
      base_path: "/government/history/10-downing-street",
    },
  ].freeze

  def self.publish_all
    PAGES.each do |page|
      payload = present_for_publishing_api(page)
      Services.publishing_api.put_content(payload[:content_id], payload[:content])
      Services.publishing_api.publish(payload[:content_id], nil, locale: "en")
    end
  end

  def self.present_for_publishing_api(page)
    {
      content_id: page[:content_id],
      content: {
        details: {
          body: TemplateContent.new(page[:template]).body,
        },
        title: page[:title],
        description: page[:description],
        document_type: "history",
        schema_name: "history",
        locale: "en",
        base_path: page[:base_path],
        publishing_app: "government-frontend",
        rendering_app: "government-frontend",
        routes: [
          {
            path: page[:base_path],
            type: "exact",
          },
        ],
        public_updated_at: Time.zone.now.iso8601,
        update_type: "minor",
      },
    }
  end

  class TemplateContent
    include ActionView::Helpers::SanitizeHelper

    def initialize(template_path)
      @template_path = template_path
    end

    def body
      strip_tags(File.read(Rails.root.join("app/views/#{@template_path}.html.erb")))
    end
  end
end
