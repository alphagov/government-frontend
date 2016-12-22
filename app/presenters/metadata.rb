module Metadata
  include Linkable
  include Updatable

  def metadata
    {
      from: from,
      first_published: published,
      last_updated: updated,
      see_updates_link: true
    }
  end

  def document_footer
    {
      from: from,
      published: published,
      updated: updated,
      history: history
    }
  end
end
