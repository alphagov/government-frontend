module UkviABTest
  def ukvi_overview_section_test?
    guide_in_ukvi_test? && (part_slug.nil? || part_slug == 'overview')
  end

  def ukvi_test_label
    if guide_under_test.include?("remain-in-uk-family")
      "ukviSpouseVisa_Remain_2017"
    elsif guide_under_test.include?("join-family-in-uk")
      "ukviSpouseVisa_Join_2017"
    end
  end

private

  def guide_under_test
    base_path.split('/')
  end

  def guide_in_ukvi_test?
    (guide_under_test.include?("remain-in-uk-family") ||
      guide_under_test.include?("join-family-in-uk"))
  end
end
