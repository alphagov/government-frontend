class ServiceManualGuidePresenter < ServiceManualPresenter
  ContentOwner = Struct.new(:title, :href)
  Change = Struct.new(:public_timestamp, :note)

  def body
    @body ||= details.fetch("body", {})
  end

  def header_links
    header_links = details.fetch("header_links", {})
    Array(header_links).map { |h| ActiveSupport::HashWithIndifferentAccess.new(h.transform_keys { |k| k == "title" ? "text" : k }) }
  end

  def content_owners
    links_content_owners_attributes.map do |content_owner_attributes|
      ContentOwner.new(content_owner_attributes["title"], content_owner_attributes["base_path"])
    end
  end

  def category_title
    category["title"] if category.present?
  end

  def breadcrumbs
    crumbs = [{ title: "Service manual", url: "/service-manual" }]
    crumbs << { title: category["title"], url: category["base_path"] } if category
    crumbs
  end

  def show_description?
    details["show_description"].present?
  end

  def public_updated_at
    timestamp = content_item["public_updated_at"]

    Time.zone.parse(timestamp) if timestamp
  end

  def visible_updated_at
    public_updated_at || updated_at
  end

  def latest_change
    change = change_history.first
    if change.present?
      Change.new(
        visible_updated_at,
        change["note"],
      )
    end
  end

  def previous_changes
    change_history.drop(1).map do |change|
      Change.new(
        Time.zone.parse(change["public_timestamp"]),
        change["note"],
      )
    end
  end

private

  def links_content_owners_attributes
    content_item.to_hash.fetch("links", {}).fetch("content_owners", [])
  end

  def category
    topic || parent
  end

  def parent
    @parent ||= Array(links["parent"]).first
  end

  def topic
    @topic ||= Array(links["service_manual_topics"]).first
  end

  def change_history
    @change_history ||= details.fetch("change_history", {})
  end

  def updated_at
    Time.zone.parse(content_item["updated_at"])
  end
end
