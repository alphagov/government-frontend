class ServiceManualHomepagePresenter < ServiceManualPresenter
  def include_search_in_header?
    false
  end

  def topics
    unsorted_topics.sort_by { |topic| topic["title"] }
  end

  def phase
    "beta"
  end

private

  def unsorted_topics
    @unsorted_topics ||= links["children"] || []
  end
end
