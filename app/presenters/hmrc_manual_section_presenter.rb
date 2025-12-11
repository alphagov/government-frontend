class HmrcManualSectionPresenter < ContentItemPresenter
  include ContentItem::Metadata
  include ContentItem::Manual
  include ContentItem::ManualSection

  def base_path
    details["manual"]["base_path"]
  end

  def breadcrumbs
    crumbs = [
      {
        title: I18n.t("manuals.breadcrumb_contents"),
        url: base_path,
      },
    ]

    return crumbs if content_item_breadcrumbs.blank?

    content_item_breadcrumbs.each do |crumb|
      crumbs.push(
        {
          title: crumb["section_id"],
          url: crumb["base_path"],
        },
      )
    end

    crumbs
  end

  def previous_and_next_links
    return unless siblings

    section_siblings = {}

    if previous_sibling
      section_siblings[:previous_page] = {
        title: I18n.t("manuals.previous_page"),
        href: previous_sibling["base_path"],
      }
    end

    if next_sibling
      section_siblings[:next_page] = {
        title: I18n.t("manuals.next_page"),
        href: next_sibling["base_path"],
      }
    end

    section_siblings
  end

private

  def previous_sibling
    adjacent_siblings.first
  end

  def next_sibling
    adjacent_siblings.last
  end

  def current_section_id
    content_item["details"]["section_id"]
  end

  def siblings
    return unless parent_for_section

    child_section_groups = parent_for_section.dig("details", "child_section_groups")

    return unless child_section_groups

    sibling_child_sections = child_section_groups.map do |group|
      included_section = group["child_sections"].find { |section| section["section_id"].include?(current_section_id) }
      group["child_sections"] if included_section.present?
    end

    sibling_child_sections.compact.flatten
  end

  def adjacent_siblings
    return unless siblings

    before, after = siblings.split do |section|
      section["section_id"] == current_section_id
    end

    [before.try(:last), after.try(:first)]
  end

  def manual
    parent_base_path == base_path ? parent_for_section : manual_content_item
  end

  def parent_base_path
    content_item_breadcrumbs.present? ? content_item_breadcrumbs.last["base_path"] : base_path
  end

  def content_item_breadcrumbs
    details["breadcrumbs"]
  end

  def parent_for_section
    @parent_for_section ||= Services.content_store.content_item(parent_base_path)
  end
end
