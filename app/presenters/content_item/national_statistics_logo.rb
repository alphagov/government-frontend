module ContentItem
  module NationalStatisticsLogo
    def logo
      return unless national_statistics?

      path = case I18n.locale.to_sym
             when :cy then "accredited-official-statistics-cy.png"
             else "accredited-official-statistics-en.png"
             end

      { path:, alt_text: I18n.t("national_statistics.logo_alt_text") }
    end
  end
end
