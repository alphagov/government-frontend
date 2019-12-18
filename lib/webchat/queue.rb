class Webchat::Queue
  include ActiveModel::Validations

  CONFIG_PATH = Rails.root.join("lib/webchat/config.yaml")

  validates_presence_of :base_path, :open_url, :availability_url

  attr_reader :base_path, :open_url, :availability_url, :provider

  def initialize(attrs)
    attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    validate!
  end

  def config
    {
      "open-url": open_url,
      "availability-url": availability_url,
      "chat-provider": provider
    }
  end

  def self.find_by_base_path(base_path)
    load_all.find { |w| w.base_path == base_path }
  end

  def self.load(params)
    parsed_params = params.dup
    new(parsed_params)
  end

  def self.load_all
    @load_all = nil if Rails.env.development?
    @load_all ||= YAML.load_file(CONFIG_PATH).map { |w| load(w) }
  end
end
