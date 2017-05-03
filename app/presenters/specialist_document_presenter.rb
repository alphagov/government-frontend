class SpecialistDocumentPresenter < ContentItemPresenter
  include Updatable
  include Linkable
  include TitleAndContext
  include Metadata

  def body
    content_item["details"]["body"]
  end

  def nested_contents
    content_item["details"]["headers"] || []
  end

  def title_and_context
    super.tap do |t|
      t.delete(:context)
    end
  end

  def metadata
    super.tap do |m|
      facets_with_friendly_values.each do |facet|
        m[:other][facet['name']] = value_or_array_of_values(facet['values'])
      end
    end
  end

  def document_footer
    super.tap do |m|
      m[:other_dates] = {}
      facets_with_friendly_values.each do |facet|
        type = facet['type'] == 'date' ? :other_dates : :other
        m[type][facet['name']] = value_or_array_of_values(facet['values'])
      end
    end
  end

  def breadcrumbs
    return [] unless finder

    [
      {
        title: "Home",
        url: "/",
      },
      {
        title: finder['title'],
        url: finder['base_path'],
      }
    ]
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

private

  def value_or_array_of_values(values)
    values.length == 1 ? values.first : values
  end

  # Finder is a required link that must have 1 item
  def finder
    parent_finder = content_item.dig("links", "finder", 0)
    Airbrake.notify("Finder not found",
      error_message: "Finder not found in #{base_path} content item"
    ) if parent_finder.nil?

    parent_finder
  end

  def facets
    return nil unless finder
    finder.dig('details', 'facets')
  end

  def facet_values
    # Metadata is a required field
    content_item["details"]["metadata"]
  end

  def facets_with_friendly_values
    sorted_facets_with_values.map do |facet|
      facet_key = facet['key']
      # Cast all values into an array
      values = [facet_values[facet_key]].flatten

      facet['values'] = case facet['type']
                        when 'date'
                          friendly_facet_date(values)
                        when 'text'
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
      .select { |f| facet_values[f['key']] && facet_values[f['key']].present? }
      .reject { |f| f['key'] == first_published_at_facet_key }
      .sort_by { |f| f['type'] }
  end

  def friendly_facet_date(dates)
    dates.map { |date| display_date(date) }
  end

  def friendly_facet_text(facet, values)
    if facet['allowed_values'] && facet['allowed_values'].any?
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
        Airbrake.notify("Facet value not in list of allowed values",
          error_message: "Facet value '#{value}' not an allowed value for facet '#{facet['name']}' on #{base_path} content item"
        )
        value
      end
    end
  end

  def facet_block(facet, allowed_value)
    friendly_value = allowed_value['label']

    return friendly_value unless facet['filterable']
    facet_link(friendly_value, allowed_value['value'], facet['key'])
  end

  def facet_link(label, value, key)
    finder_base_path = finder['base_path']
    link_to(label, "#{finder_base_path}?#{key}%5B%5D=#{value}")
  end

  def first_published_at_facet_key
    'first_published_at'
  end

  # first_published_at does not have reliable data
  # at time of writing dates could be after public_updated_at
  # details.first_public_at is not provided
  # https://trello.com/c/xCJ3RN6W/
  #
  # Instead use first date in change history
  def first_public_at
    if facet_values[first_published_at_facet_key]
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
end
