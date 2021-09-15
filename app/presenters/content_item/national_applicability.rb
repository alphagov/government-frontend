module ContentItem
  module NationalApplicability
    include Metadata

    def national_applicability
      content_item["details"]["national_applicability"]&.deep_symbolize_keys
    end
  end
end
