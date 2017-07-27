atom_feed(root_url: @content_item.web_url, id: @content_item.web_url) do |feed|
  feed.title("Travel Advice Summary")
  feed.updated @content_item.atom_public_updated_at
  feed.author do |author|
    author.name "GOV.UK"
  end
  feed.entry(@content_item, id: "#{@content_item.web_url}##{@content_item.atom_public_updated_at}", url: @content_item.web_url, updated: @content_item.atom_public_updated_at) do |entry|
    entry.title(@content_item.title)
    entry.link(rel: "self", type: "application/atom+xml", href: "#{@content_item.web_url}.atom")
    entry.summary(type: :xhtml) do |summary|
      summary << @content_item.atom_change_description
    end
  end
end
