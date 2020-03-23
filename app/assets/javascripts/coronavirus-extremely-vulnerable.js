//= require multivariate-test

$(function(){
  // x minutes in days: x / (60 minutes * 24 hours)
  var minutesForCohort = 2,
    minutesInDay = 1440; // 60 * 24

  if(window.location.href.indexOf("/coronavirus-extremely-vulnerable") > -1) {
    // Get the current cohort or assign one if it has not been already
    GOVUK.MultivariateTest.prototype.getCohort = function() {
      var cohort = GOVUK.cookie(this.cookieName());
      if (!cohort || !this.cohorts[cohort]) {
        cohort = this.chooseRandomCohort();
        GOVUK.cookie(this.cookieName(), cohort, {days: minutesForCohort / minutesInDay});
      }
      return cohort;
    };

    GOVUK.MultivariateTest.prototype.setCustomVar = function(cohort) {
      if (this.customDimensionIndex) {
        GOVUK.analytics.setDimension(
          this.customDimensionIndex,
          this.cookieName() + "__" + cohort
        );
      }
    };

    var bContent = $('#answer-b-content').html();
    var pcThreshold = 20;

    new GOVUK.MultivariateTest({
      el: '.answer',
      name: 'multivariatetest_cohort_coronavirus_extremely_vulnerable_rate_limit_202003',
      customDimensionIndex: 14,
      cohorts: {
        a: { callback: function() {}, variantId: 0, weight: 100 - pcThreshold },
        b: { callback: function() {
          $('.answer').replaceWith(bContent);
        }, variantId: 1, weight: pcThreshold },
      }
    });
  }
});
