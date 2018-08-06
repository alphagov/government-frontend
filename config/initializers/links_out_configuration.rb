# Loads configuration for taxonomy navigation links at app/presenters/links_out
Rails.configuration.taxonomy_navigation_links_out = JSON.parse(File.read('config/links_out.json'))
