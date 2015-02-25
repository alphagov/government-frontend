module AvailableLanguagesHelper
  def native_language_name_for(locale)
    I18n.t("language_names.#{locale}", locale: locale)
  end
end
