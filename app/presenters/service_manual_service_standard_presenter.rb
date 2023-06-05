class ServiceManualServiceStandardPresenter < ServiceManualPresenter
  attr_reader :poster_url

  def initialize(*)
    super
    @poster_url = details["poster_url"]
  end

  def points
    Point.load(points_attributes).sort
  end

  def breadcrumbs
    [
      { title: "Service manual", url: "/service-manual" },
    ]
  end

  def email_alert_signup_link
    "/email-signup?link=#{content_item['base_path']}"
  end

  def show_default_breadcrumbs?
    false
  end

private

  def points_attributes
    @points_attributes ||= links["children"] || []
  end

  class Point
    include Comparable

    attr_reader :title, :description, :base_path

    def self.load(points_attributes)
      points_attributes.map { |point_attributes| new(point_attributes) }
    end

    def initialize(attributes, *_args)
      @title = attributes["title"]
      @description = attributes["description"]
      @base_path = attributes["base_path"]
    end

    def <=>(other)
      number <=> other.number
    end

    def title_without_number
      @title_without_number ||= title.sub(/\A(\d*)\.(\s*)/, "")
    end

    def number
      @number ||= Integer(title.scan(/\A(\d*)/)[0][0])
    end
  end
end
