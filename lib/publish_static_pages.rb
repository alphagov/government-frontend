module PublishStaticPages
  PAGES = [
    {
      content_id: "14aa298f-03a8-4e76-96de-483efa3d001f",
      title: "History of 10 Downing Street",
      description: "10 Downing Street, the locale of British prime ministers since 1735, vies with the White House as being the most important political building anywhere in the world in the modern era.",
      template: "histories/10_downing_street",
      base_path: "/government/history/10-downing-street",
    },
    {
      content_id: "9bdb6017-48c9-4590-b795-3c19d5e59320",
      title: "History of 11 Downing Street",
      description: "The history of 11 Downing Street.",
      template: "histories/11_downing_street",
      base_path: "/government/history/11-downing-street",
    },
    {
      content_id: "7be62825-1538-4ff5-aa29-cd09350349f2",
      title: "History of 1 Horse Guards Road",
      descriotion: "The history of 1 Horse Guards Road.",
      template: "histories/1_horse_guards_road",
      base_path: "/government/history/1-horse-guards-road",
    },
    {
      content_id: "bd216990-c550-4d28-ac05-649329298601",
      title: "History of King Charles Street (FCO)",
      description: "The history of King Charles Street.",
      template: "histories/king_charles_street",
      base_path: "/government/history/king-charles-street",
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
