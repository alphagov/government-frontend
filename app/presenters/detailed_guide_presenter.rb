class DetailedGuidePresenter < ContentItemPresenter
  include Political
  include ExtractsHeadings
  include Linkable
  include Updatable
  include Withdrawable
  include ActionView::Helpers::UrlHelper

  def body
    content_item["details"]["body"]
  end

  def breadcrumbs
    return [] unless parent

    e = parent
    res = []

    while e
      res << { title: e["title"], url: e["base_path"] }
      e = e["parent"] && e["parent"].first
    end

    res << { title: "Home", url: "/" }
    res.reverse
  end

  def contents
    extract_headings_with_ids(body).map do |heading|
      link_to(heading[:text], "##{heading[:id]}")
    end
  end

  def context
    parent["title"]
  end

  def related_guides
    links("related_guides")
  end

  def related_mainstream
    links("related_mainstream")
  end

  def applies_to
    return nil if !national_applicability
    all_nations = national_applicability.values
    applicable_nations = all_nations.select { |n| n["applicable"] }
    inapplicable_nations = all_nations - applicable_nations

    applies_to = applicable_nations.map { |n| n["label"] }.to_sentence

    if inapplicable_nations.any?
      nations_with_alt_urls = inapplicable_nations.select { |n| n["alternative_url"].present? }
      if nations_with_alt_urls.any?
        additional_guidance_links = nations_with_alt_urls
          .map { |n| link_to(n['label'], n['alternative_url'], rel: :external) }
          .to_sentence
        # TODO: Translation for `see detailed guidance for` below?
        additional_guidance = " (see detailed guidance for #{additional_guidance_links})"
        applies_to += additional_guidance
      end
    end

    applies_to
  end

private

  def national_applicability
    content_item["details"]["national_applicability"]
  end

  def parent
    if content_item["links"].include?("parent")
      content_item["links"]["parent"][0]
    end
  end
end
