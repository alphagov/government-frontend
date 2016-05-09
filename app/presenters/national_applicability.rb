module NationalApplicability
  def applies_to
    return nil if !national_applicability
    all_nations = national_applicability.values
    applicable_nations = all_nations.select { |n| n["applicable"] }
    inapplicable_nations = all_nations - applicable_nations

    applies_to = applicable_nations.map { |n| n["label"] }.to_sentence

    if inapplicable_nations.any?
      nations_with_alt_urls = inapplicable_nations.select { |n| n["alternative_url"].present? }
      if nations_with_alt_urls.any?
        alternate_links = nations_with_alt_urls
          .map { |n| link_to(n['label'], n['alternative_url'], rel: :external) }
          .to_sentence

        applies_to += " (see #{translated_format_name} for #{alternate_links})"
      end
    end

    applies_to
  end

private

  def translated_format_name
    I18n.t("content_item.format.#{format}", count: 1).downcase
  end

  def national_applicability
    content_item["details"]["national_applicability"]
  end
end
