require 'test_helper'

class TasklistContentTest < ActiveSupport::TestCase
  setup do
    @config = TasklistContent.learn_to_drive_config
  end

  test "be configured for a sidebar" do
    assert_equal 3, @config[:tasklist][:heading_level]
    assert_equal true, @config[:tasklist][:small]
  end

  test "have symbolized keys" do
    @config.keys.each do |key|
      assert key.is_a? Symbol
    end
  end

  test "have a link in the correct structure" do
    first_link = @config[:tasklist][:groups][0][0][:panel_links][0]
    assert_equal "/vehicles-can-drive", first_link[:href]
    assert_equal "Check what age you can drive", first_link[:text]
  end
end
