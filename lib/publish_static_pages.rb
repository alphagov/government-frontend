module PublishStaticPages
  PAGES = [
    {
      content_id: "dbe329f1-359c-43f7-8944-580d4742aa91",
      document_type: "get_involved",
      schema_name: "get_involved",
      title: "Get involved",
      template: "content_items/get_involved",
      description: "Find out how you can engage with government directly, and take part locally, nationally or internationally.",
      base_path: "/government/get-involved",
    },
    {
      content_id: "14aa298f-03a8-4e76-96de-483efa3d001f",
      document_type: "history",
      schema_name: "history",
      title: "History of 10 Downing Street",
      description: "10 Downing Street, the locale of British prime ministers since 1735, vies with the White House as being the most important political building anywhere in the world in the modern era.",
      template: "histories/10_downing_street",
      base_path: "/government/history/10-downing-street",
    },
    {
      content_id: "9bdb6017-48c9-4590-b795-3c19d5e59320",
      document_type: "history",
      schema_name: "history",
      title: "History of 11 Downing Street",
      description: "The history of 11 Downing Street.",
      template: "histories/11_downing_street",
      base_path: "/government/history/11-downing-street",
    },
    {
      content_id: "7be62825-1538-4ff5-aa29-cd09350349f2",
      document_type: "history",
      schema_name: "history",
      title: "History of 1 Horse Guards Road",
      descriotion: "The history of 1 Horse Guards Road.",
      template: "histories/1_horse_guards_road",
      base_path: "/government/history/1-horse-guards-road",
    },
    {
      content_id: "bd216990-c550-4d28-ac05-649329298601",
      document_type: "history",
      schema_name: "history",
      title: "History of King Charles Street (FCDO)",
      description: "The history of King Charles Street.",
      template: "histories/king_charles_street",
      base_path: "/government/history/king-charles-street",
    },
    {
      content_id: "60808448-769d-4915-981c-f34eb5f1b7bc",
      document_type: "history",
      schema_name: "history",
      title: "History of Lancaster House (FCDO)",
      description: "The history of Lancaster House.",
      template: "histories/lancaster_house",
      base_path: "/government/history/lancaster-house",
    },
    {
      content_id: "db95a864-874f-4f50-a483-352a5bc7ba18",
      document_type: "history",
      schema_name: "history",
      title: "History of the UK government",
      description: "In this section you can read short biographies of notable people and explore the history of government buildings. You can also search our online records and read articles and blog posts by historians.",
      template: "histories/history",
      base_path: "/government/history",
    },
  ].freeze

  def self.publish_all
    PAGES.each do |page|
      payload = present_for_publishing_api(page)

      Services.publishing_api.put_path(page[:base_path], publishing_app: "government-frontend", override_existing: true)
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
        document_type: page[:document_type],
        schema_name: page[:schema_name],
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
