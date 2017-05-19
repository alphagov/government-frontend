class AnswerPresenter < ContentItemPresenter
  include Body
  include LastUpdated

  def ab_body
    b_button = <<EOD
      <div class="transaction">
        <p class="get-started group">
          <a id="epilepsy-driving-variant-b" class="button" href="https://www.driving-medical-condition.service.gov.uk/eligibility/entitlement-gb">
            Report your condition online
          </a>
        </p>
      </div>

        <p>You can also <a href="/government/publications/fep1-confidential-medical-information">fill in form FEP1</a> and send it to DVLA. The address is on the form.</p>
EOD

    body.gsub(
        /<p>You can either <a href="\/report-driving-medical-condition">report your condition online<\/a> or <a href="\/government\/publications\/fep1-confidential-medical-information">fill in form FEP1<\/a> and send it to <abbr title="Driver Vehicle and Licensing Agency">DVLA<\/abbr>. The address is on the form.<\/p>/,
        b_button
    )
  end
end
