module ApplicationHelper
  def direction
    content_for(:direction)
  end

  def wrapper_class
    "direction-#{direction}" if direction
  end
end
