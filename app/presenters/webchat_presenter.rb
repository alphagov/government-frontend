class WebchatPresenter
  def initialize(base_path)
    @base_path = base_path
  end

  def webchat
    @webchat ||= Webchat.find(@base_path)
  end

  def show_default_breadcrumbs? = true

  def content_item = self
  def page_title = webchat.title

  def heading_and_context
    { text: page_title, heading_level: 1, margin_bottom: 8, font_size: "xl" }
  end

  def webchat_body = webchat.more_info_webchat

  def open_url_redirect? = webchat.open_url_redirect.present?
  def redirect_attribute = open_url_redirect? ? "true" : "false"

  def parsed_content
    @parsed_content ||= {
      "details" => {
        "body" => webchat.more_info_webchat,
        "quick_links" => webchat.quick_links&.map do |link|
          {
            "title" => link["title"],
            "url" => "#{Plek.new.website_root}#{link['url']}",
          }
        end || [],
      },
    }
  end

  def to_h
    @to_h ||= {
      "base_path" => @base_path,
      "title" => page_title,
      "schema_name" => schema_name,
      "details" => parsed_content["details"],
      "links" => {
        "parent" => webchat.parent ? [webchat.parent] : [],
      },
    }
  end

  def parsed_content_item = to_h

  def ga4_link_data
    {
      event_name: "navigation",
      type: "webchat",
      text: I18n.t("shared.webchat.speak_to_adviser", locale: :en),
    }.to_json
  end

  delegate :availability_url, :open_url, :csp_connect_src,
           :description, :schema_name, to: :webchat
end
