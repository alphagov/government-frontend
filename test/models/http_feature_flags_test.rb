require 'test_helper'

class HttpFeatureFlagsTest < ActiveSupport::TestCase
  test 'instance should create a singleton instance' do
    instance = HttpFeatureFlags.instance
    instance.add_http_feature_flag('TEST_HEADER', 'show')

    new_instance = HttpFeatureFlags.instance
    feature_enabled = new_instance.feature_enabled?('TEST_HEADER', 'TEST_HEADER' => 'show')

    assert_equal(true, feature_enabled)
  end

  test 'add_http_feature_flag should set a new feature flag' do
    instance = HttpFeatureFlags.new

    feature_enabled = instance.feature_enabled?('USE_MAGIC', 'USE_MAGIC' => 'only_at_weekends')
    assert_equal(false, feature_enabled)

    instance.add_http_feature_flag('USE_MAGIC', 'only_at_weekends')
    feature_enabled = instance.feature_enabled?('USE_MAGIC', 'USE_MAGIC' => 'only_at_weekends')
    assert_equal(true, feature_enabled)
  end

  test 'feature_enabled? should return false when feature flag has not been set' do
    instance = HttpFeatureFlags.new

    feature_enabled = instance.feature_enabled?('USE_MAGIC', 'USE_MAGIC' => 'only_at_weekends')
    assert_equal(false, feature_enabled)
  end

  test 'feature_enabled? should return false when header has not been set' do
    instance = HttpFeatureFlags.new

    instance.add_http_feature_flag('USE_MAGIC', 'only_at_weekends')
    feature_enabled = instance.feature_enabled?('USE_MAGIC', {})
    assert_equal(false, feature_enabled)
  end

  test 'feature_enabled? should return false when header has been set but does not match specified value' do
    instance = HttpFeatureFlags.new

    instance.add_http_feature_flag('USE_MAGIC', 'only_at_weekends')
    feature_enabled = instance.feature_enabled?('USE_MAGIC', 'USE_MAGIC' => 'all_the_time')
    assert_equal(false, feature_enabled)
  end

  test 'feature_enabled? should return true when headers has been set and matches specified value' do
    instance = HttpFeatureFlags.new

    instance.add_http_feature_flag('USE_MAGIC', 'only_at_weekends')
    feature_enabled = instance.feature_enabled?('USE_MAGIC', 'USE_MAGIC' => 'only_at_weekends')
    assert_equal(true, feature_enabled)
  end
end
