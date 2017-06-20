#This is intended as a temporary solution while dependencies on other apps are
#resolved. We are migrating world locations to a taxonomy based model but the
#following problems have arisen that this approach temporarily solves:
#
# * we require world locations to be associated with content in Whitehall
#   for email subscriptionas to work so we can't just get rid of them
# * we also need them as not all content will be part of the taxonomy
#   (e.g. news about the country)
# * the taxon will take the base path (/world/<country-slug>) and so the
#   WorldLocation can't occupy that
# * we need to redirect old /government/world/<country-slug> urls to the new
#   taxon but if we leave WorldLocation with that path it will a) overwrite
#   the redirect route every time it is updated and b) we'll be knowingly
#   linking to a redirect
#
#A slightly better solution will be for Whitehall to retrieve the taxon path from
#publishing API and send that with the world location link as an additional field
#in the links. We'll need the taxonomy to exist in order to implement this. Thiw
#will still require frontend code to know about the links but will be similar
#to prior art we have for some links to be affected by elements with `detail`.
#
class WorldLocationBasePath
  EXCEPTIONAL_CASES = {
    "Democratic Republic of Congo" => "democratic-republic-of-congo",
    "South Georgia and the South Sandwich Islands" => "south-georgia-and-the-south-sandwich-islands",
    "St Pierre & Miquelon" => "st-pierre-miquelon"
  }.freeze

  class << self
    def for(world_location_link)
      base_path = world_location_link["base_path"]
      title = world_location_link["title"]
      return base_path if base_path.present?

      slug = EXCEPTIONAL_CASES[title] ||
        title.parameterize

      "/government/world/#{slug}"
    end
  end
end
