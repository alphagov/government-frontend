class ServiceManualTopicPresenter < ServiceManualPresenter
  ContentOwner = Struct.new(:title, :href)

  attr_reader :visually_collapsed
  alias_method :visually_collapsed?, :visually_collapsed

  def initialize(content_item, *args)
    super
    @visually_collapsed = content_item["details"]["visually_collapsed"]
  end

  def breadcrumbs
    parent_breadcrumbs
  end

  def groups
    linked_items = content_item["links"]["linked_items"]
    topic_groups = Array(content_item["details"]["groups"]).map do |group_data|
      ServiceManualTopicPresenter::TopicGroup.new(group_data, linked_items)
    end
    topic_groups.select(&:present?)
  end

  def content_owners
    @content_owners ||= Array(content_item["links"]["content_owners"]).map do |data|
      ContentOwner.new(data["title"], data["base_path"])
    end
  end

  def email_alert_signup_link
    "/email-signup?link=#{content_item['base_path']}"
  end

  def phase
    "beta"
  end

  def visually_expanded?
    !visually_collapsed?
  end

  def display_as_accordion?
    groups.count > 2 && visually_collapsed?
  end

  def accordion_content
    # Each accordion needs a hash, as shown in the GOV.UK Publishing Components
    # guide: https://components.publishing.service.gov.uk/component-guide/accordion
    #
    # This method returns the content in the required shape from the hash
    # supplied by the `groups` method.

    groups.each.with_index(1).map do |section, index|
      {
        data_attributes: {
          ga4: {
            event_name: "select_content",
            type: "accordion",
            text: section.name,
            index:,
            index_total: groups.length,
          },
        },
        heading: {
          text: section.name,
        },
        summary: {
          text: section.description,
        },
        content: {
          html: accordion_section_links(section.linked_items),
        },
        expanded: visually_expanded?,
      }
    end
  end

private

  def accordion_section_links(links)
    # Expects `links` to be an array of hashes containing `href` and `label`
    # for the link. For example:
    #
    # ```ruby
    # [
    #   {
    #     label: 'Link to example',
    #     href: 'http://example.com'
    #   }
    # ]
    # ```
    #
    # This will return santitised HTML in a string. The above example would
    # return:
    #
    # ```html
    # <ul class="govuk-list">
    #   <li>
    #     <a href="http://example.com" class="govuk-link">Link to example</a>
    #   </li>
    # </ul>
    # ```

    links = links.map do |linked_item|
      link_html = ActionController::Base.helpers.link_to(linked_item.label, linked_item.href, class: "govuk-link")
      "<li>#{link_html}</li>"
    end

    list = "<ul class=\"govuk-list\">#{links.join('')}</ul>"

    ActionController::Base.helpers.sanitize(list)
  end

  def parent_breadcrumbs
    [
      {
        title: "Service manual",
        url: "/service-manual",
      },
    ]
  end
end
