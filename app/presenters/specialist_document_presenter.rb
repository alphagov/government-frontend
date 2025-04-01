class SpecialistDocumentPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Updatable
  include ContentItem::Linkable
  include ContentItem::HeadingAndContext
  include ContentItem::Metadata
  include TypographyHelper
  include ContentItem::ContentsList

  def heading_and_context
    super.tap do |t|
      t.delete(:context)
    end
  end

  def contents
    @contents ||=
      show_contents_list? ? headers_to_contents(nested_headers.clone) : []
  end

  def metadata
    super.tap do |m|
      m.delete(:first_published) if bulk_published?
    end
  end

  def important_metadata
    super.tap do |m|
      facets_with_values.each do |facet|
        m.merge!(friendly_facet_values_for_key("key", facet))
        m.merge!(friendly_facet_values_for_key("sub_facet_key", facet)) if facet["type"] == "nested"
      end
    end
  end

  def friendly_facet_values_for_key(key, facet)
    facet_values_for_content_item = [content_item_metadata[facet[key]]].flatten
    friendly_facet_values = friendly_facet_values(facet, key, facet_values_for_content_item)
    name = key == "key" ? facet["name"] : facet["sub_facet_name"]
    { name => value_or_array_of_values(friendly_facet_values) }
  end

  def continuation_link
    content_item
      .dig("details", "metadata", "continuation_link")
      .try(:strip)
      .try(:html_safe)
  end

  def will_continue_on
    content_item
      .dig("details", "metadata", "will_continue_on")
      .try(:strip)
      .try(:html_safe)
  end

  def finder_link
    if finder && statutory_instrument?
      view_context.link_to("See all #{finder['title']}", finder["base_path"], class: "govuk-link")
    end
  end

  def protected_food_drink_name?
    content_item["document_type"] == "protected_food_drink_name"
  end

  def protection_type
    content_item.dig("details", "metadata", "protection_type")
  end

  def images
    {
      "protected-designation-of-origin-pdo" => {
        "url" => view_context.image_url("protected-food-drink-names/protected-designation-of-origin-pdo.png"),
        "alt_text" => I18n.t("specialist_document.pdo_alt_text"),
      },
      "protected-geographical-indication-pgi" => {
        "url" => view_context.image_url("protected-food-drink-names/protected-geographical-indication-pgi.png"),
        "alt_text" => I18n.t("specialist_document.pgi_alt_text"),
      },
      "traditional-speciality-guaranteed-tsg" => {
        "url" => view_context.image_url("protected-food-drink-names/traditional-speciality-guaranteed-tsg.png"),
        "alt_text" => I18n.t("specialist_document.tsg_alt_text"),
      },
    }
  end

  def show_metadata_block?
    content_item.dig("links", "finder", 0, "details", "show_metadata_block")
  end

private

  def nested_headers
    content_item["details"]["headers"] || []
  end

  def headers_to_contents(headers)
    headers.map do |header|
      header.deep_symbolize_keys!
      header[:href] = "##{header[:id]}"
      header.delete(:level)
      header[:text] = strip_trailing_colons(header[:text])

      if header[:headers]
        header[:items] = headers_to_contents(header[:headers])
        header.delete(:headers)
      end

      header
    end
  end

  def value_or_array_of_values(values)
    values.length == 1 ? values.first : values
  end

  def finder
    content_item.dig("links", "finder", 0)
  end

  def facets
    @facets ||= finder&.dig("details", "facets")
  end

  def content_item_metadata
    # Metadata is a required field
    content_item["details"]["metadata"]
  end

  def facets_with_values
    return [] unless facets && content_item_metadata.any?

    facets
      .select { |f| content_item_metadata[f["key"]] && content_item_metadata[f["key"]].present? }
      .reject { |f| f["key"] == first_published_at_facet_key }
      .reject { |f| f["key"] == internal_notes_facet_key }
  end

  def friendly_facet_values(facet, key, facet_values_for_content_item)
    return friendly_facet_date(facet_values_for_content_item) if facet["type"] == "date"
    return friendly_facet_text(facet, key, facet_values_for_content_item) if %w[text nested].include?(facet["type"])

    facet_values_for_content_item
  end

  def friendly_facet_date(dates)
    dates.map { |date| DateTimeHelper.display_date(date) }
  end

  def friendly_facet_text(facet, key, values)
    return values if facet["allowed_values"].blank?

    values.map { |value| friendly_facet_label(facet, key, value) }
  end

  def friendly_facet_label(facet, key, value)
    allowed_value = if key == "key"
                      facet["allowed_values"].detect { |av| av["value"] == value }
                    elsif key == "sub_facet_key"
                      facet["allowed_values"].pluck("sub_facets").flatten.compact.detect { |av| av["value"] == value }
                    end

    return default_facet_value_if_not_found(facet, value) unless allowed_value

    label = if allowed_value["main_facet_label"].present?
              [allowed_value["main_facet_label"], allowed_value["label"]].join(" - ")
            else
              allowed_value["label"]
            end

    return label unless facet["filterable"]

    facet_link(label, allowed_value, facet[key])
  end

  def default_facet_value_if_not_found(facet, value)
    GovukError.notify(
      "Facet value not in list of allowed values",
      extra: { error_message: "Facet value '#{value}' not an allowed value for facet '#{facet['name']}' on #{base_path} content item" },
    )
    value
  end

  def facet_link(label, allowed_value, key)
    finder_base_path = finder["base_path"]
    url = "#{finder_base_path}?#{facet_link_query_params(allowed_value, key)}"
    view_context.link_to(label, url, class: "govuk-link govuk-link--inverse")
  end

  def facet_link_query_params(allowed_value, key)
    query_params = { key => allowed_value["value"] }

    if allowed_value["main_facet_value"]
      main_facet = main_facet_for_sub_facet(key)
      query_params[main_facet["key"]] = allowed_value["main_facet_value"] if main_facet
    end

    query_params.to_query
  end

  def main_facet_for_sub_facet(sub_facet_key)
    facets&.detect { |f| f["sub_facet_key"] == sub_facet_key }
  end

  def first_published_at_facet_key
    "first_published_at"
  end

  def internal_notes_facet_key
    "internal_notes"
  end

  # first_published_at does not have reliable data
  # at time of writing dates could be after public_updated_at
  # details.first_public_at is not provided
  # https://trello.com/c/xCJ3RN6W/
  #
  # Instead use first date in change history
  def first_public_at
    @first_public_at ||= if content_item_metadata[first_published_at_facet_key]
                           content_item_metadata[first_published_at_facet_key]
                         else
                           changes = reverse_chronological_change_history
                           changes.any? ? changes.last[:timestamp] : nil
                         end
  end

  # specialist document change history can have a modified date that is
  # slightly different to the public_updated_at, eg milliseconds different
  # this means the direct comparison in updatable gives a false positive
  # Use change_history as specialist-frontend did
  #
  # Can be removed when first_published_at is reliable
  def any_updates?
    change_history.size > 1
  end

  # Bulk published essentially means published without a correct first published date
  # eg For certain AAIB reports the publish date is the date the site was scraped
  # rather than the date the report was first published
  #
  # https://trello.com/c/FhAbqDhg/77-3-aaib-dates-prior-to-10-dec-2014-needs-to-be-suppressed
  # https://govuk.zendesk.com/agent/tickets/2293473
  #
  # Example:
  # https://www.gov.uk/aaib-reports/lockheed-l1011-385-1-15-g-bhbr-19-december-1989
  def bulk_published?
    content_item_metadata["bulk_published"].present?
  end

  def statutory_instrument?
    content_item["document_type"] == "statutory_instrument"
  end
end
