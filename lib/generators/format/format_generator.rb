require 'json'
require 'rails/generators'

class FormatGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_format_files
    @format_name = file_name.underscore
    @dashed_name = @format_name.dasherize
    @camel_name = @format_name.camelize

    template 'format_presenter.rb.erb', "app/presenters/#{@format_name}_presenter.rb"
    template 'format_presenter_test.rb.erb', "test/presenters/#{@format_name}_presenter_test.rb"
    template 'format_integration_test.rb.erb', "test/integration/#{@format_name}_test.rb"

    template '_format.scss', "app/assets/stylesheets/views/_#{@dashed_name}.scss"
    append_to_file "app/assets/stylesheets/application.scss", "@import \"views/#{@dashed_name}\";\n"

    template 'format.html.erb', "app/views/content_items/#{@format_name}.html.erb"
  end
end
