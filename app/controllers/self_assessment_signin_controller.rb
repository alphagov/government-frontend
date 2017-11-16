class SelfAssessmentSigninController < ApplicationController
  include TasklistHeaderABTestable
  include TasklistABTestable
  include SelfAssessmentABTestable

  rescue_from GdsApi::HTTPForbidden, with: :error_403
  rescue_from GdsApi::HTTPNotFound, with: :error_notfound
  rescue_from GdsApi::InvalidUrl, with: :error_notfound
  rescue_from ActionView::MissingTemplate, with: :error_406
  rescue_from ActionController::UnknownFormat, with: :error_406

  attr_accessor :content_item

  def choose_sign_in
    @content_item = set_up_self_assessment_ab_content_item
    set_up_traffic_signs_summary_ab_testing
    @error = params[:error]
    render template: 'content_items/signin/choose-sign-in'
  end

  def not_registered
    @content_item = set_up_self_assessment_ab_content_item
    set_up_traffic_signs_summary_ab_testing
    render template: 'content_items/signin/not-registered'
  end

  def lost_account_details
    @content_item = set_up_self_assessment_ab_content_item
    set_up_traffic_signs_summary_ab_testing
    render template: 'content_items/signin/lost-account-details'
  end

  def sign_in_options
    if params["sign-in-option"] == "government-gateway"
      redirect_to "https://www.tax.service.gov.uk/account"
    elsif params["sign-in-option"] == "govuk-verify"
      redirect_to "https://www.tax.service.gov.uk/ida/sa/login?SelfAssessmentSigninTestVariant=B"
    elsif params["sign-in-option"] == "lost-account-details"
      redirect_to lost_account_details_path
    else
      redirect_to choose_sign_in_path error: true
    end
  end
end
