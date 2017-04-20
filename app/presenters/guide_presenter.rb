class GuidePresenter < ContentItemPresenter
  def page_title
    if @part_slug
      "#{title}: #{current_part_title}"
    else
      title
    end
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

private

  def current_part_index
    parts.index(current_part)
  end
end
