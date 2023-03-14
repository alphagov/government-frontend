class HowGovernmentWorksPresenter < ContentItemPresenter
  def prime_minister
    content_item.dig("links", "current_prime_minister", 0)
  end

  def prime_minister_image_url
    prime_minister.dig("details", "image", "url")
  end

  def prime_minister_image_alt_text
    prime_minister.dig("details", "image", "alt_text")
  end

  def reshuffle_in_progress?
    content_item.dig("details", "reshuffle_in_progress")
  end

  def ministerial_role_counts
    content_item.dig("details", "ministerial_role_counts")
  end

  def department_counts
    content_item.dig("details", "department_counts")
  end

  def agencies_and_other_public_bodies
    "#{department_counts['agencies_and_public_bodies'].floor(-2)}+"
  end
end
