ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  def read_content_store_fixture(basename)
    File.read(Rails.root.join("test", "fixtures", "content_store", "#{basename}.json"))
  end

end
