class BodyParser
  def initialize(body)
    @body = body
  end

  def title_and_link_sections
    if raw_title_and_link_sections.any?
      raw_title_and_link_sections.map do |section|
        s = parse(section)
        {
          title: parsed_title(s),
          links: parsed_links(s),
        }
      end
    end
  end

private

  attr_reader :body

  def parse(html)
    Nokogiri::HTML.parse(html)
  rescue Nokogiri::XML::SyntaxError
    ""
  end

  def parsed_body
    @parsed_body ||= parse(body)
  end

  def raw_body_content
    if parsed_body.present?
      parsed_body.search("div.govspeak").children
    end
  end

  def raw_title_and_link_sections
    if raw_body_content.any?
      raw_body_content.to_s.split(/(?=<h2 )/)
    end
  end

  def parsed_links(section)
    raw_links = section.css("a") if section.present?
    if raw_links.any?
      raw_links.map { |link| parse_link(link) }
    else
      []
    end
  end

  def parse_link(raw_link)
    {
      path: format_path(raw_link["href"]),
      text: raw_link.content,
    }
  end

  def parsed_title(section)
    parsed = { text: "", id: "" }

    raw_header = section.at_css("h2") if section.present?
    if raw_header.present?
      id = raw_header.attribute("id")
      parsed[:text] = raw_header.content
      parsed[:id] = id.value if id.present?
    end
    parsed
  end

  def format_path(raw_url)
    uri = URI.parse(raw_url)
    uri.host == "www.gov.uk" ? uri.path : raw_url
  end
end
