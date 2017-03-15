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
      m[:other] = facet_metadata
    end
  end

  def document_footer
    super.tap do |m|
      m[:other] = facet_metadata
    end
  end

private

  # Maximum of one finder
  # but finder may be empty
  def finder
    content_item.dig("links", "finder", 0)
    # TODO: Shout loudly if missing parent finder
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
                        when 'text'
                          friendly_facet_text(facet, values)
                        when 'date'
                          friendly_facet_date(values)
                        else
                          values
                        end

      facet
    end
  end

  def friendly_facet_text(facet, values)
    if facet['allowed_values'] && facet['allowed_values'].any?
      friendly_facet_allowed_values(facet, values)
    else
      values
    end
  end

  def friendly_facet_allowed_values(facet, values)
    # TODO: Shout loudly if a value isn't one of the allowed ones
    facet['allowed_values'].select { |v| values.include?(v['value']) }.map do |allowed_value|
      facet['filterable'] ? filterable_facet_link(facet, allowed_value) : allowed_value['label']
    end
  end

  def friendly_facet_date(dates)
    dates.map { |date| display_date(date) }
  end

  def filterable_facet_link(facet, allowed_value)
    finder_base_path = finder['base_path']
    key = facet['key']

    link_to(allowed_value['label'], "#{finder_base_path}?#{key}%5B%5D=#{allowed_value['value']}")
  end

  def facet_metadata
    metadata = {}
    facets_with_values.each do |facet|
      metadata[facet['name']] = facet['values'].join(', ')
    end

    metadata
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
end
