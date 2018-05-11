class WorkingGroupPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include ContentItem::TitleAndContext

  def email
    content_item["details"]["email"]
  end

  def contents_items
    super + extra_headings
  end

  def policies
    # When we upgrade to Ruby 2.3.0, this could be simplified with `dig`:
    # http://ruby-doc.org/core-2.3.0/Hash.html#method-i-dig
    return [] unless content_item["links"] && content_item["links"]["policies"]
    content_item["links"]["policies"]
  end

  def title_and_context
    super.tap do |t|
      t.delete(:average_title_length)
      t.delete(:context)
    end
  end

  def structured_data
    # TODO: implement a schema
    {}
  end

private

  def extra_headings
    extra_headings = []
    extra_headings << { id: "policies", text: "Policies" } if policies.any?
    extra_headings << { id: "contact-details", text: "Contact details" } if email.present?
    extra_headings
  end

  def first_item
    return if body.nil?
    if parsed_body.css("h2").empty?
      parsed_body.css("div").first.try(:first_element_child)
    else
      super
    end
  end
end
