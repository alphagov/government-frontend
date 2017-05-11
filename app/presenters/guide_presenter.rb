class GuidePresenter < ContentItemPresenter
  include Parts
  include UkviABTest

  def page_title
    if @part_slug
      "#{title}: #{current_part_title}"
    else
      title
    end
  end

  def has_parts?
    Airbrake.notify("Guide with no parts",
      error_message: "Guide rendered without any parts at #{base_path}"
    ) unless parts.any?

    parts.any?
  end

  def multi_page_guide?
    parts.size > 1
  end

  def current_part_title_with_index
    "#{current_part_index + 1}. #{current_part_title}"
  end

  def print_link
    "#{base_path}/print"
  end

  def related_items
    @nav_helper.related_items
  end
end
