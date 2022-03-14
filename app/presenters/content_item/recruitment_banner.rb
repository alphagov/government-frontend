module ContentItem
  module RecruitmentBanner
    USER_RESEARCH_PAGES = %w[register-for-self-assessment self-employed-records income-tax-rates].freeze

    def show_study_banner?
      USER_RESEARCH_PAGES.include?(slug)
    end
  end
end
