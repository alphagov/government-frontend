module RelatedNavigationHelper
  def format_data_for_related_navigation(related_content, other_links)
    other_links.each do |sections|
      sections.each do |section|
        related_content.push(
          section[:title].tr(' ', '_') => section[:links]
        )
      end
    end
    related_content
  end

  def construct_section_heading(section_title)
    unless section_title === "related_items"
      t('components.related_navigation.' + section_title, default: section_title.tr('_', ' '))
    end
  end

  def construct_section_styling(section_title, defined_sections)
    if defined_sections.include? section_title
      ""
    else
      "--other"
    end
  end

  def remaining_links(links, max_section_length)
    links.length - max_section_length
  end
end
