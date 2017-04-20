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

  def previous_and_next_navigation
    nav = {}

    nav[:previous_page] = {
      url: "#{base_path}/#{previous_part['slug']}",
      title: "Previous",
      label: previous_part['title']
    } if previous_part

    nav[:next_page] = {
      url: "#{base_path}/#{next_part['slug']}",
      title: "Next",
      label: next_part['title']
    } if next_part

    nav
  end

private

  def next_part
    parts[current_part_index + 1]
  end

  def previous_part
    parts[current_part_index - 1] if current_part_index > 0
  end

  def current_part_index
    parts.index(current_part)
  end
end
