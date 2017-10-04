require 'component_test_helper'

class PublicationHeaderTest < ComponentTestCase
  def component_name
    "publication-header"
  end

  test "fails to render a publication-header when no properties are supplied" do
    assert_raise do
      render_component({})
    end
  end
end

# This component renders some content using the static title component, which cannot currently be tested using the approach above.
# To cover this gap, below is an integration test that loads the publication header page in the component guide in order to test
# that the remaining aspects of the component are being rendered correctly.

class PublicationHeaderTitleTest < ActionDispatch::IntegrationTest
  test "renders a publication header" do
    visit '/component-guide/publication-header/default'

    within '.component-guide-preview' do
      assert page.has_selector?(".app-c-publication-header")
    end
  end

  test "renders a publication header with a title" do
    visit '/component-guide/publication-header/default'

    within '.component-guide-preview' do
      assert_has_component_title("Budget 2016")
    end
  end

  test "renders a publication header with last changed date" do
    visit '/component-guide/publication-header/default'

    within '.component-guide-preview' do
      assert page.has_selector?(".app-c-publication-header__last-changed", text: "Updated 16 March 2016")
    end
  end
end
