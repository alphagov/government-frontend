module ContentItem
  module NationalApplicability
    include Metadata

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

          applies_to += " (see #{translated_schema_name(nations_with_alt_urls.count)} for #{alternate_links})"
        end
      end

      applies_to
    end

    def metadata
      super.tap do |m|
        m[:other]['Applies to'] = applies_to
      end
    end

    def publisher_metadata
      super.tap do |m|
        m[:other] = { 'Applies to': applies_to }.merge(m[:other])
      end
    end

  private

    def translated_schema_name(count)
      I18n.t("content_item.schema_name.#{schema_name}", count: count).downcase
    end

    def national_applicability
      content_item["details"]["national_applicability"]
    end
  end
end
