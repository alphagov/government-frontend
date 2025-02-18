class FieldOfOperationPresenter < ContentItemPresenter
  include ContentItem::HeadingAndContext

  FatalityNotice = Struct.new(:roll_call_introduction, :casualties, :title, :base_path)

  def heading_and_context
    super.tap do |t|
      t[:context] = I18n.t("field_of_operation.context")
      t[:text] = "#{I18n.t('field_of_operation.title')} #{@content_item['title']}"
      t[:font_size] = "xl"
    end
  end

  def organisation
    org = @content_item.dig("links", "primary_publishing_organisation", 0)
    logo = org.dig("details", "logo")

    {
      name: logo["formatted_title"].html_safe,
      url: org["base_path"],
      brand: org.dig("details", "brand"),
      crest: logo["crest"],
    }
  end

  def description
    description = @content_item["description"]

    description.html_safe if description.present?
  end

  def fatality_notices
    notices = @content_item.dig("links", "fatality_notices")
    return [] unless notices

    notices.map do |notice|
      FatalityNotice.new(
        notice.dig("details", "roll_call_introduction"),
        notice.dig("details", "casualties"),
        notice["title"],
        notice["base_path"],
      )
    end
  end

  def contents
    contents = []
    contents << { href: "#field-of-operation", text: "Field of operation" } if description.present?
    contents << { href: "#fatalities", text: "Fatalities" } if fatality_notices.present?

    contents
  end
end
