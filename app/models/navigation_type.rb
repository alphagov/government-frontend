class NavigationType
  GUIDANCE_SCHEMAS =
    %w{answer contact guide detailed_guide document_collection publication}.freeze

  def initialize(presented_content_item)
    @content_item = presented_content_item
  end

  def should_present_taxonomy_navigation?
    !@content_item.tagged_to_browse_pages? &&
      @content_item.tagged_to_a_taxon? &&
      content_schema_is_guidance?
  end

private

  def content_schema_is_guidance?
    GUIDANCE_SCHEMAS.include? @content_item.schema_name
  end
end
