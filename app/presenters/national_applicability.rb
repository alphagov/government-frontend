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
        additional_guidance_links = nations_with_alt_urls
          .map { |n| link_to(n['label'], n['alternative_url'], rel: :external) }
          .to_sentence

        additional_guidance = " (see detailed guidance for #{additional_guidance_links})"
        applies_to += additional_guidance
      end
    end

    applies_to
  end

private

  def national_applicability
    content_item["details"]["national_applicability"]
  end
end
