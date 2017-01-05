class SpeechPresenter < ContentItemPresenter
  include Linkable
  include Political
  include Updatable
  include TitleAndContext
  include Metadata

  def body
    content_item["details"]["body"]
  end

  def image
    content_item["details"]["image"]
  end

  def delivery_type
    if document_type == 'authored_article'
      'Written on'
    else
      'Delivered on'
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

  def metadata
    super.tap do |m|
      m[:other] = {
        "Location" => location,
        delivery_type => delivered_on_metadata
      }
    end
  end

private

  def location
    content_item["details"]["location"]
  end

  def delivered_on
    delivered_on_date = content_item["details"]["delivered_on"]
    content_tag(:time, display_date(delivered_on_date), datetime: delivered_on_date)
  end

  def speech_type_explanation
    explanation = content_item["details"]["speech_type_explanation"]
    " (#{explanation})" if explanation
  end

  def speaker_without_profile
    content_item["details"]["speaker_without_profile"]
  end
end
