class TopicalEventAboutPagePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include ContentItem::TitleAndContext

  # Old topical event pages have a "archived" string appended to their title
  # which we also include in the breadcrumbs of topical event about pages
  # for example: https://www.gov.uk/government/topical-events/ebola-virus-government-response/about
  def breadcrumbs
    result = super
    result.last[:title] = parent['title'] if parent
    result
  end

  def title_and_context
    super.tap do |t|
      t.delete(:average_title_length)
      t.delete(:context)
    end
  end

private

  def parent
    return nil unless super
    topical_event_end_date = super.dig("details", "end_date")

    if topical_event_end_date && Time.zone.parse(topical_event_end_date) <= Time.zone.today
      super.merge("title" => "#{super['title']} (Archived)")
    else
      super
    end
  end
end
