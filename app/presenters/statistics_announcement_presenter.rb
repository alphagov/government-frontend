class StatisticsAnnouncementPresenter < ContentItemPresenter
  include ActionView::Helpers::UrlHelper

  def from
    content_item["links"]["organisations"].map { |org|
      link_to(org["title"], org["base_path"])
    }
  end

  def part_of
    content_item["links"]["policy_areas"].map { |policy_area|
      link_to(policy_area["title"], policy_area["base_path"])
    }
  end
end
