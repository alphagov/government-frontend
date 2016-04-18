class CaseStudyPresenter < ContentItemPresenter
  include ActionView::Helpers::UrlHelper
  include CommonSections

  attr_reader :body, :format_display_type

  def initialize(content_item)
    super
    @body = content_item["details"]["body"]
    @format_display_type = content_item["details"]["format_display_type"]
  end

  def image
    content_item["details"]["image"]
  end

  def withdrawn?
    content_item["details"].include?("withdrawn_notice")
  end

  def page_title
    withdrawn? ? "[Withdrawn] #{title}" : title
  end

  def part_of
    links("document_collections") + links("related_policies") + links("worldwide_priorities") + links("world_locations")
  end

  def withdrawal_notice
    notice = content_item["details"]["withdrawn_notice"]
    if notice
      {
        time: content_tag(:time, display_time(notice["withdrawn_at"]), datetime: notice["withdrawn_at"]),
        explanation: notice["explanation"]
      }
    end
  end
end
