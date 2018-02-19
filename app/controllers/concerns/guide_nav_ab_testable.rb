module GuideNavAbTestable
  DIMENSION = 64
  TEST_NAME = "GuideChapterNav".freeze

  def self.included(base)
    base.helper_method(
      :guide_test_variant,
      :is_tested_guide?,
      :show_alternate_guide_chapters?
    )

    base.after_action :set_guide_test_response_header
  end

  def guide_test
    @guide_nav_test ||= set_ab_test(
      name: TEST_NAME,
      dimension: DIMENSION
    )
  end

  def guide_test_variant
    @guide_test_variant ||=
      guide_test.requested_variant(request.headers)
  end

  def show_alternate_guide_chapters?
    guide_test_variant.variant?('B') && is_tested_guide?
  end

  def is_tested_guide?
    is_guide? && !is_education?
  end

  def set_guide_test_response_header
    guide_test_variant.configure_response(response) if is_tested_guide?
  end

private

  def is_guide?
    content_item.is_a?(GuidePresenter)
  end

  def is_education?
    @is_education ||= root_taxon_slugs(content_item.content_item).include?("/education")
  end

  def root_taxon_slugs(content_item)
    root_taxon_set = Set.new

    links = content_item["links"]

    parent_taxons = (links["parent_taxons"] || links["taxons"]) unless links.nil?
    if parent_taxons.blank?
      root_taxon_set << content_item["base_path"] if content_item["document_type"] == 'taxon'
    else
      parent_taxons.each do |parent_taxon|
        root_taxon_set += root_taxon_slugs(parent_taxon)
      end
    end
    root_taxon_set
  end

  def set_ab_test(name:, dimension:)
    GovukAbTesting::AbTest.new(name, dimension: dimension)
  end
end
