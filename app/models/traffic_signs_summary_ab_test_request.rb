class TrafficSignsSummaryAbTestRequest
  attr_accessor :requested_variant

  delegate :analytics_meta_tag, to: :requested_variant

  def initialize(request, content_item)
    @content_item = content_item
    @ab_test = GovukAbTesting::AbTest.new("TrafficSignsSummary", dimension: 81)
    @requested_variant = @ab_test.requested_variant(request.headers)
  end

  def ab_test_applies?
    @content_item["base_path"] == "/government/publications/know-your-traffic-signs"
  end

  def should_present_old_summary?
    ab_test_applies? && @requested_variant.variant?("B")
  end

  def with_old_summary(content_item)
    OldTrafficSignsContentItem.new(content_item)
  end

  def set_response_vary_header(response)
    @requested_variant.configure_response response
  end

  class OldTrafficSignsContentItem < SimpleDelegator
    def description
      # From http://webarchive.nationalarchives.gov.uk/20170605215458/https://www.gov.uk/government/publications/know-your-traffic-signs
      "Guidance on road traffic signage in Great Britain."
    end
  end
end
