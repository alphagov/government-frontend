require 'test_helper'

class DevelopmentControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  %w(A B).each do |test_variant|
    test "RelatedLinksABTest2 works correctly for each variant (variant: #{test_variant})" do
      with_variant RelatedLinksABTest2: test_variant do
        get :index

        ab_test = @controller.send(:related_links_test)
        requested = ab_test.requested_variant(request.headers)
        assert requested.variant?(test_variant)
      end
    end
  end
end
