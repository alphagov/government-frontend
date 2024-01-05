module AbTests
  def self.included(base)
    base.helper_method :ab_test_variant, :ab_test_page?
    base.after_action :set_ab_test_response_header
  end

  def ab_test_config
    # TODO - put all the stuff that's currently in config/ab_tests.yml in @content_item as a link,
    # then we could do all the configuration of the AB tests in the publishing apps, and not need
    # to hardcode andy of the config ✨
    # We also wouldn't need the base_paths config, as we could tell if a content item was supposed
    # to be AB tested simply based on whether it was linked to AB test config.
    @ab_test_config ||= Rails.configuration.x.ab_tests.find do |config|
      config.base_paths.any? { |base_path| @content_item.base_path == base_path } && body.include?(config.placeholder)
    end
  end

  def ab_test_page?
    ab_test_config.present?
  end

  def ab_test_variant
    return unless ab_test_page?

    @ab_test_variant ||= ab_test.requested_variant(request.headers)
  end

  def ab_test
    return unless ab_test_page?

    @ab_test ||= GovukAbTesting::AbTest.new(
      ab_test_config.name,
      dimension: ab_test_config.dimension,
      allowed_variants: ab_test_config.variants.keys,
      control_variant: ab_test_config.default_variant,
    )
  end

  def body
    # TODO - it's gross having to guess which method to use to get the body.
    # Is there a nicer way to do this? Could we alias current_part_body to body on the Presenter?
    # Or some other way of doing it?
    if @content_item.respond_to?(:current_part_body)
      @content_item.current_part_body 
    elsif @content_item.respond_to?(:body)
      @content_item.body 
    else
      nil
    end
  end

  def ab_test_replace_placeholder!
    return unless ab_test_page?

    replacement = ab_test_config.variants.fetch(
      ab_test_variant.variant_name,
      ab_test_config.variants.fetch(ab_test_config.default_variant)
    )
    # TODO - it's a little bit gross to be mutating this string... 🤷
    body.sub!(ab_test_config.placeholder, replacement)
  end

  def set_ab_test_response_header
    ab_test_variant.configure_response(response) if ab_test_page?
  end
end