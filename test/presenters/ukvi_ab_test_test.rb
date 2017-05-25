require "test_helper"

module UkviStubs
  def base_path
    test_path
  end

  def part_slug
    test_path.split('/').length > 2 ? test_path.split('/').last : nil
  end
end

class UkviABTestTest < ActiveSupport::TestCase
  def setup
    @ukvi_test = OpenStruct.new
    @ukvi_test.extend(UkviABTest)
    @ukvi_test.extend(UkviStubs)
  end

  [
    '/any-other-guide',
    '/any-other-guide/overview',
    '/remain-in-uk-family/a-different-part'
  ].each do |test_path|
    test "#{test_path} are not in test" do
      @ukvi_test.test_path = test_path
      refute @ukvi_test.ukvi_overview_section_test?
      refute @ukvi_test.ukvi_knowledge_section_test?
    end
  end

  [
    '/remain-in-uk-family',
    '/remain-in-uk-family/overview',
    '/join-family-in-uk',
    '/join-family-in-uk/overview'
  ].each do |test_path|
    test "#{test_path} is in overview test" do
      @ukvi_test.test_path = test_path
      assert @ukvi_test.ukvi_overview_section_test?
    end
  end

  [
    '/remain-in-uk-family',
    '/remain-in-uk-family/overview'
  ].each do |test_path|
    test "#{test_path} is labelled as remain test" do
      @ukvi_test.test_path = test_path
      assert_equal @ukvi_test.ukvi_test_label, "ukviSpouseVisa_Remain_2017"
    end
  end

  [
    '/join-family-in-uk',
    '/join-family-in-uk/overview'
  ].each do |test_path|
    test "#{test_path} is labelled as join test" do
      @ukvi_test.test_path = test_path
      assert_equal @ukvi_test.ukvi_test_label, "ukviSpouseVisa_Join_2017"
    end
  end
end
