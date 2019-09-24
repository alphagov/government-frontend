class GuidePresenter < ContentItemPresenter
  include ContentItem::Parts

  attr_accessor :draft_access_token

  def page_title
    if @part_slug
      "#{super}: #{current_part_title}"
    else
      super
    end
  end

  def has_parts?
    unless parts.any?
      GovukError.notify(
        "Guide with no parts",
        extra: { error_message: "Guide rendered without any parts at #{base_path}" }
      )
    end

    parts.any?
  end

  def multi_page_guide?
    parts.size > 1
  end

  def print_link
    "#{base_path}/print"
  end

  # Append token parameters to part paths to allow fact-checkers to fact-check all pages
  def parts
    if draft_access_token
      super.each do |part|
        part["full_path"] = "#{part['full_path']}?#{draft_access_token_param}"
      end
    else
      super
    end
  end

  def show_guide_navigation?
    multi_page_guide? && !hide_chapter_navigation?
  end

  def content_title
    if parts.any?
      return current_part_title if hide_chapter_navigation?
    end

    title
  end

private

  def draft_access_token_param
    "token=#{draft_access_token}" if draft_access_token
  end

  def hide_chapter_navigation?
    hide_navigation_elements = content_item.parsed_content["details"]["hide_chapter_navigation"]
    part_of_step_navs? && hide_navigation_elements
  end

  def part_of_step_navs?
    content_item.parsed_content["links"]["part_of_step_navs"].present?
  end
end
