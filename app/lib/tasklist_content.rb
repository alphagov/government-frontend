class TasklistContent
  def self.learn_to_drive_config
    @learn_to_drive_config ||= parse_file
  end

  def self.parse_file(file: "learn-to-drive-a-car.json")
    JSON.parse(
      File.read(
        Rails.root.join("config", "tasklists", file)
        )
      ).deep_symbolize_keys
  end
end
