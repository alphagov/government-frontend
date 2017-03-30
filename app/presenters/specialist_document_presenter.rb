class SpecialistDocumentPresenter < ContentItemPresenter
  include Updatable
  include Linkable
  include ContentsList
  include TitleAndContext
  include Metadata

  def body
    content_item["details"]["body"]
  end

  def title_and_context
    super.tap do |t|
      t.delete(:context)
    end
  end

  def metadata
    super.tap do |m|
      facets_with_values.each do |facet|
        m[:other][facet['name']] = facet['values'].join(', ')
      end
    end
  end

  def document_footer
    super.tap do |m|
      m[:other_dates] = {}
      facets_with_values.each do |facet|
        type = facet['type'] == 'date' ? :other_dates : :other
        m[type][facet['name']] = facet['values'].join(', ')
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

private

  def finder
    first_finder = content_item.dig("links", "finder", 0)
    Airbrake.notify("Finder not found",
      error_message:
        "All specialist documents should have at least one finder"
    ) if first_finder.nil?
    first_finder
  end

  def facets
    return nil unless finder
    finder.dig('details', 'facets')
  end

  def facet_values
    # Metadata is a required field
    content_item["details"]["metadata"]
  end

  def facets_with_values
    return [] unless facets && facet_values.any?
    only_facets_with_values = facets.select { |f| facet_values[f['key']] }

    only_facets_with_values.map do |facet|
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

  def friendly_facet_date(dates)
    dates.map { |date| display_date(date) }
  end

  def friendly_facet_text(facet, values)
    if facet['allowed_values'] && facet['allowed_values'].any?
      check_allowed_values(facet, values)
      facet_blocks(facet, values)
    else
      values
    end
  end

  def check_allowed_values(facet, values)
    allowed_values = facet['allowed_values'].map { |av| av["value"] }
    not_allowed = "facet value not in list of allowed values"

    values.each do |v|
      Airbrake.notify(not_allowed) unless allowed_values.include?(v)
    end
  end

  # the facet value comes back bare, and without a label
  # so we use the value in the url, and cross reference
  # the allowed_values to get the label ##funky
  def facet_blocks(facet, values)
    values.map do |value|
      values_with_label = facet["allowed_values"]
      allowed_value = values_with_label.select { |av|
        av["value"] == value
      }.first
      facet_block(facet, allowed_value)
    end
  end

  def facet_block(facet, allowed_value)
    return allowed_value['label'] unless facet['filterable']
    facet_link(allowed_value['label'], allowed_value['value'], facet['key'])
  end

  def facet_link(label, value, key)
    finder_base_path = finder['base_path']
    link_to(label, "#{finder_base_path}?#{key}%5B%5D=#{value}")
  end


  # first_published_at does not have reliable data
  # at time of writing dates could be after public_updated_at
  # details.first_public_at is not provided
  # https://trello.com/c/xCJ3RN6W/
  #
  # Instead use first date in change history
  def first_public_at
    changes = reverse_chronological_change_history
    changes.any? ? changes.last[:timestamp] : nil
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
