class GuidePresenter < ContentItemPresenter
  include ContentItem::Parts
  include ContentItem::OrganisationBranding

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

  def current_part_title_with_index
    "#{current_part_index + 1}. #{current_part_title}"
  end

  def print_link
    "#{base_path}/print"
  end

  def related_items
    @nav_helper.related_items
  end

  def taxons
    content_item["links"]["taxons"]
  end

  def organisations
    orgs = content_item["links"]["organisations"] || []
    orgs.sort_by { |o| o["title"] }
  end

  def organisation_logo(organisation)
    super.tap do |logo|
      if logo && organisations.count > 1
        logo[:organisation].delete(:image)
      end
    end
  end

  def related_stuff(rummager_args)
    results = Services.rummager.search({ count: 5, fields: %w[title public_timestamp link content_store_document_type]}.merge(rummager_args))["results"]

    items = results.map do |r|
      {
        link: { text: r["title"], path: r["link"] },
        metadata: { public_updated_at: Time.parse(r["public_timestamp"]), document_type: "other" }
      }
    end

    { items: items }
  end

  # Append token parameters to part paths to allow fact-checkers to fact-check all pages
  def parts
    if draft_access_token
      super.each do |part|
        part['full_path'] = "#{part['full_path']}?#{draft_access_token_param}"
      end
    else
      super
    end
  end

private

  def draft_access_token_param
    "token=#{draft_access_token}" if draft_access_token
  end
end
