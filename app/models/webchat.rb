class Webchat
  include ActiveModel::Validations

  CONFIG_PATH = Rails.root.join("lib/webchat.yaml")

  validates_presence_of :base_path, :open_url, :availability_url

  attr_reader :base_path, :open_url, :availability_url, :open_url_redirect

  def initialize(attrs)
    @base_path = attrs["base_path"] if attrs["base_path"].present?
    @open_url = attrs["open_url"] if attrs["open_url"].present?
    @availability_url = attrs["availability_url"] if attrs["availability_url"].present?
    @open_url_redirect = attrs.fetch("open_url_redirect", nil)
    validate!
  end

  def self.find(base_path)
    load_all.find { |w| w.base_path == base_path }
  end

  def self.load_all
    @load_all ||= YAML.load_file(CONFIG_PATH).map { |page_config| new(page_config) }
  end
end
