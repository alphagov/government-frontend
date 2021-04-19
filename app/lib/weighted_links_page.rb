class WeightedLinksPage
  include ActiveModel::Validations

  CONFIG_PATH = Rails.root.join("app/lib/weighted_links_pages.yaml")

  attr_accessor :page_base_path, :related_links

  validates_presence_of :page_base_path, :related_links
  validate { errors.add(:related_links, "is not an array") unless related_links.is_a? Array }

  def initialize(attrs)
    attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    validate!
  end

  def self.find_page_with_base_path(base_path)
    load_all.find do |page|
      page.page_base_path == base_path
    end
  end

  def self.load(params)
    new(params)
  end

  def self.load_all
    @load_all ||= YAML.load_file(CONFIG_PATH)["weighted_links_pages"].map { |page| load(page) }
  end
end
