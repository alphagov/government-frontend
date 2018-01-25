module Navigation
  module Mainstream
    def related_navigation
      nav = super
      nav.delete(:publishers)
      nav
    end
  end
end
