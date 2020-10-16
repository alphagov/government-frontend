class SpecialistDocumentPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Updatable
  include ContentItem::Linkable
  include ContentItem::TitleAndContext
  include ContentItem::Metadata
  include TypographyHelper
  include ContentItem::ContentsList

  def title_and_context
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
      facets_with_friendly_values.each do |facet|
        m.merge!(facet["name"] => value_or_array_of_values(facet["values"]))
      end
    end
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
      view_context.link_to("See all #{finder['title']}", finder["base_path"])
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
        "alt_text" => "The scheme logo is a black stamp with the words Designated Origin UK Protected",
      },
      "protected-geographical-indication-pgi" => {
        "url" => view_context.image_url("protected-food-drink-names/protected-geographical-indication-pgi.png"),
        "alt_text" => "The scheme logo is a black stamp with the words Geographic Origin UK Protected",
      },
      "traditional-speciality-guaranteed-tsg" => {
        "url" => view_context.image_url("protected-food-drink-names/traditional-speciality-guaranteed-tsg.png"),
        "alt_text" => "The scheme logo is a black stamp with the words Traditional Speciality UK Protected",
      },
    }
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

  # Finder is a required link that must have 1 item
  def finder
    parent_finder = content_item.dig("links", "finder", 0)
    if parent_finder.nil?
      GovukError.notify(
        "Finder not found",
        extra: { error_message: "Finder not found in #{base_path} content item" },
      )
    end

    parent_finder
  end

  def facets
    return nil unless finder

    finder.dig("details", "facets")
  end

  def facet_values
    # Metadata is a required field
    content_item["details"]["metadata"]
  end

  def facets_with_friendly_values
    sorted_facets_with_values.map do |facet|
      facet_key = facet["key"]
      # Cast all values into an array
      values = [facet_values[facet_key]].flatten

      facet["values"] = case facet["type"]
                        when "date"
                          friendly_facet_date(values)
                        when "text"
                          friendly_facet_text(facet, values)
                        else
                          values
                        end

      facet
    end
  end

  def sorted_facets_with_values
    return [] unless facets && facet_values.any?

    facets
      .select { |f| facet_values[f["key"]] && facet_values[f["key"]].present? }
      .reject { |f| f["key"] == first_published_at_facet_key }
      .reject { |f| f["key"] == internal_notes_facet_key }
      .sort_by { |f| f["type"] }
  end

  def friendly_facet_date(dates)
    dates.map { |date| display_date(date) }
  end

  def friendly_facet_text(facet, values)
    if facet["allowed_values"] && facet["allowed_values"].any?
      facet_blocks(facet, values)
    else
      values
    end
  end

  # The facet value is hyphenated, map this to the
  # friendly readable version provided in `allowed_values`
  def facet_blocks(facet, values)
    values.map do |value|
      allowed_value = facet["allowed_values"].detect { |av| av["value"] == value }

      if allowed_value
        facet_block(facet, allowed_value)
      else
        GovukError.notify(
          "Facet value not in list of allowed values",
          extra: { error_message: "Facet value '#{value}' not an allowed value for facet '#{facet['name']}' on #{base_path} content item" },
        )
        value
      end
    end
  end

  def facet_block(facet, allowed_value)
    friendly_value = allowed_value["label"]

    return friendly_value unless facet["filterable"]

    facet_link(friendly_value, allowed_value["value"], facet["key"])
  end

  def facet_link(label, value, key)
    finder_base_path = finder["base_path"]
    view_context.link_to(
      label,
      "#{finder_base_path}?#{key}%5B%5D=#{value}",
      class: "govuk-link app-link",
    )
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
    @first_public_at ||= if facet_values[first_published_at_facet_key]
                           facet_values[first_published_at_facet_key]
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
    facet_values["bulk_published"].present?
  end

  def statutory_instrument?
    content_item["document_type"] == "statutory_instrument"
  end
end
