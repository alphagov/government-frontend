class WraithConfigHelper
  attr_accessor :name, :paths

  TEMPLATE_PATH = "test/wraith/config.yaml".freeze
  OUTPUT_PATH = 'test/wraith/wip-config-%{suffix}.yaml'.freeze

  def initialize(name, paths)
    @name = name
    @paths = paths
  end

  def create_config(extra_config = {})
    config = load_template
    config["paths"] = build_paths

    if ENV['HEROKU_APP_NAME'].present?
      config["domains"]["local"] = "https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com"
    end

    config.merge!(extra_config) if extra_config.present?
    write_config(config)
  end

private

  def load_template
    YAML::load(File.open(TEMPLATE_PATH))
  end

  def build_paths
    config_paths = {}

    if @paths.is_a? Hash
      @paths.keys.each do |key|
        @paths.fetch(key).each_with_index do |path, index|
          config_paths[path_index(key, index + 1)] = path
        end
      end
    else
      @paths.each_with_index { |path, index| config_paths[path_index(name, index + 1)] = path }
    end

    config_paths
  end

  def path_index(prefix, index)
    "#{prefix}_#{index}"
  end

  def write_config(config)
    file_name = OUTPUT_PATH % { suffix: @name }
    File.open(file_name, 'w') { |f| f.write config.to_yaml }
    file_name
  end
end
