class ManualSectionPresenter < ContentItemPresenter
  include ContentItem::Metadata
  include ContentItem::Manual
  include ContentItem::ManualSection

  def base_path
    manual["base_path"]
  end

  def intro
    return nil unless details["body"]

    intro = Nokogiri::HTML::DocumentFragment.parse(details["body"])

    # Strip all content following and including h2
    intro.css("h2").xpath("following-sibling::*").remove
    intro.css("h2").remove

    intro.text.squeeze == "\n" ? "" : intro
  end

  def visually_expanded?
    details.fetch("visually_expanded", false)
  end

  def main
    return nil unless details["body"]

    document = Nokogiri::HTML::DocumentFragment.parse(details["body"])

    # Identifies all h2's and creates an array of objects from the heading and
    # its proceeding content up to the next heading. This is so that it can be
    # consumed by accordion components in the template.
    document.css("h2").map do |heading|
      content = []
      heading.xpath("following-sibling::*").each do |element|
        if element.name == "h2"
          break
        else
          content << element.to_html
        end
      end

      {
        heading: {
          text: heading.text,
          id: heading[:id],
        },
        content: content.join,
      }
    end
  end

private

  def manual
    content_item["links"]["manual"].first
  end
end
