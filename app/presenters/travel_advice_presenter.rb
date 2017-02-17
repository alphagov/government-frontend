class TravelAdvicePresenter < ContentItemPresenter
  def title_and_context
    {
      context: 'Foreign travel advice',
      title: country_name
    }
  end

  def related_items
    items = ordered_related_items.map do |link|
      {
        title: link["title"],
        url:  link["base_path"]
      }
    end

    {
      sections: [
        {
          title: 'Elsewhere on GOV.UK',
          items: items
        }
      ]
    }
  end

private

  def country_name
    content_item["details"]["country"]["name"]
  end
  def ordered_related_items
    content_item["links"]["ordered_related_items"] || []
  end
end
