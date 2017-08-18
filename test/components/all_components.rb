require 'component_test_helper'

# TODO: Move this logic to the GOVUK Publishing Components gem
# and have the tests visit each component.
class AllComponentsTest < ActionDispatch::IntegrationTest
  test "renders all component guide pages without erroring" do
    visit '/component-guide'
    components = all(:css, '.component-list a').map do |el|
      "#{el[:href]}/preview"
    end
    components.each do |component|
      visit component
    end
  end
end
