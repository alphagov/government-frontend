class WorldLocationBasePath
  class << self
    def for(world_location_link)
      base_path = world_location_link["base_path"]
      title = world_location_link["title"]
      return base_path if base_path.present?

      slug = title.parameterize

      "/world/#{slug}/news"
    end
  end
end
