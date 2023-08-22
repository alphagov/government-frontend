class Webchat
  include ActiveModel::Validations

  CONFIG_PATH = Rails.root.join("lib/webchat.yaml")

  validates :base_path, :open_url, :availability_url, presence: true

  attr_reader :base_path, :open_url, :availability_url, :open_url_redirect, :csp_connect_src

  def initialize(attrs)
    @base_path = attrs["base_path"]
    @open_url = attrs["open_url"]
    @availability_url = attrs["availability_url"]
    @open_url_redirect = attrs["open_url_redirect"]
    @csp_connect_src = attrs["csp_connect_src"]&.split(",")
    validate!
  end

  def self.find(base_path)
    load_all.find { |w| w.base_path == base_path }
  end

  def self.load_all
    @load_all ||= YAML.load_file(CONFIG_PATH).map { |page_config| new(page_config) }
  end
end
