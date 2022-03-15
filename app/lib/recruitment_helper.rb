module RecruitmentHelper
  USER_RESEARCH_PAGES = %w[register-for-self-assessment self-employed-records income-tax-rates].freeze

  def self.show_banner?(slug)
    USER_RESEARCH_PAGES.include?(slug)
  end
end
