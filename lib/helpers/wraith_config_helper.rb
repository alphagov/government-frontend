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
    config.deep_merge!(extra_config) if extra_config.present?

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
          config_paths[path_index(key, index + 1)] = path unless path_blacklisted?(path)
        end
      end
    else
      @paths.each_with_index do |path, index|
        config_paths[path_index(name, index + 1)] = path unless path_blacklisted?(path)
      end
    end

    config_paths
  end

  def path_index(prefix, index)
    "#{prefix}_#{index}"
  end

  # Remove paths that aren't useful
  #
  # TODO: Remove when Wraith patched
  # Paths containing "path" in them break Wraith:
  # https://github.com/BBC-News/wraith/issues/536
  #
  # TODO: Remove when Search API no longer returns
  # Search API incorrectly returns government-frontend as
  # renderer for travel advice index
  def path_blacklisted?(path)
    path.include?('path') || path == "/foreign-travel-advice"
  end

  def write_config(config)
    file_name = OUTPUT_PATH % { suffix: @name }
    File.open(file_name, 'w') { |f| f.write config.to_yaml }
    file_name
  end
end
