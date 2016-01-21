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

  def release_date
    content_item["details"]["display_date"]
  end

  def release_date_and_status
    return "#{release_date} (#{state})" unless state == "cancelled"
    release_date
  end

  def national_statistics?
    content_item["details"]["format_sub_type"] == 'national'
  end

private

  def state
    content_item["details"]["state"]
  end
end
