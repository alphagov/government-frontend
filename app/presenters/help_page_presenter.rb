class HelpPagePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::LastUpdated

  def structured_data
    # TODO: implement a schema
    {}
  end
end
