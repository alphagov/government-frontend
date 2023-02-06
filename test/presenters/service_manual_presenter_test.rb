require "presenter_test_helper"

class ServiceManualPresenterTest < PresenterTestCase
  test "#links" do
    presenter = create_presenter(ServiceManualPresenter, content_item: { "links" => { "something" => [] } })
    assert_equal ({ "something" => [] }), presenter.links
  end

  test "#details" do
    presenter = create_presenter(ServiceManualPresenter, content_item: { "description" => "Description" })
    assert_equal "Description", presenter.description
  end
end
