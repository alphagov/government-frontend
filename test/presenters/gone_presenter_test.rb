require "test_helper"

class GonePresenterTest < ActiveSupport::TestCase
  test "presents the basic details required to display an gone" do
    assert_equal gone["details"]["explanation"], presented_gone.explanation
    assert_equal gone["details"]["alternative_path"], presented_gone.alternative_path
  end

  def gone
    govuk_content_schema_example("gone", "gone")
  end

  def presented_gone
    GonePresenter.new(gone)
  end
end
