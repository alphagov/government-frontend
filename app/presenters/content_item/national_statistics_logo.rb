module ContentItem
  module NationalStatisticsLogo
    def logo
      return unless national_statistics?

      { path: "national-statistics.png", alt_text: "National Statistics" }
    end
  end
end
