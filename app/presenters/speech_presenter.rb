class SpeechPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Linkable
  include ContentItem::Political
  include ContentItem::Updatable
  include ContentItem::HeadingAndContext
  include ContentItem::Metadata
  include ContentItem::NewsImage

  def delivery_type
    if document_type == "authored_article"
      I18n.t("speech.written_on")
    else
      I18n.t("speech.delivered_on")
    end
  end

  def delivered_on_metadata
    "#{delivered_on}#{speech_type_explanation}"
  end

  def from
    super.tap do |f|
      f.push(speaker_without_profile) if speaker_without_profile
    end
  end

  def important_metadata
    super.tap do |m|
      m.merge!(I18n.t("speech.location") => location, delivery_type => delivered_on_metadata)
    end
  end

private

  def location
    content_item["details"]["location"]
  end

  def delivered_on
    delivered_on_date = content_item["details"]["delivered_on"]
    view_context.tag.time(DateTimeHelper.display_date(delivered_on_date), datetime: delivered_on_date)
  end

  def speech_type_explanation
    explanation = content_item["details"]["speech_type_explanation"]
    " (#{explanation})" if explanation
  end

  def speaker_without_profile
    content_item["details"]["speaker_without_profile"]
  end
end
