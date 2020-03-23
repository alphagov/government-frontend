MultivariateTest.prototype.setUpContentExperiment = function(cohort) {
var contentExperimentId = this.contentExperimentId;
var cohortVariantId = this.cohorts[cohort]['variantId'];
if(contentExperimentId && cohortVariantId && typeof window.ga === "function"){
if(typeof contentExperimentId !== 'undefined' &&
  typeof cohortVariantId !== 'undefined' &&
  typeof window.ga === "function"){
  window.ga('set', 'expId', contentExperimentId);
  window.ga('set', 'expVar', cohortVariantId);
};
