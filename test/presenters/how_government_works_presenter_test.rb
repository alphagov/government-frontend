require "presenter_test_helper"

class HowGovernmentWorksPresenterTest < PresenterTestCase
  def schema_name
    "how_government_works"
  end

  test "presents the basic details of a content item" do
    assert_equal schema_item("reshuffle-mode-off")["title"], presented_item("reshuffle-mode-off").title
    assert_equal schema_item("reshuffle-mode-off")["description"], presented_item("reshuffle-mode-off").description
  end

  test "presents the current prime minister" do
    assert_equal(
      schema_item("reshuffle-mode-off").dig("links", "current_prime_minister", 0),
      presented_item("reshuffle-mode-off").prime_minister,
    )
  end

  test "presents the presence of reshuffle mode" do
    assert_equal schema_item("reshuffle-mode-on")["details"]["reshuffle_in_progress"], presented_item("reshuffle-mode-on").reshuffle_in_progress?
  end

  test "presents the ministerial role count" do
    assert_equal schema_item("reshuffle-mode-off")["details"]["ministerial_role_counts"], presented_item("reshuffle-mode-off").ministerial_role_counts
  end

  test "presents the department count" do
    assert_equal schema_item("reshuffle-mode-off")["details"]["department_counts"], presented_item("reshuffle-mode-off").department_counts
  end
end
