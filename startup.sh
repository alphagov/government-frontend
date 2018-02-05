#!/bin/bash

bundle install

if [[ $1 == "--live" ]] ; then
  GOVUK_APP_DOMAIN=www.gov.uk \
  GOVUK_WEBSITE_ROOT=https://www.gov.uk \
  PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://www.gov.uk/api} \
  PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.publishing.service.gov.uk} \
  PLEK_SERVICE_RUMMAGER_URI=${PLEK_SERVICE_RUMMAGER_URI-https://www.gov.uk/api} \
  bundle exec foreman run web
elif [[ $1 == "--dummy" ]] ; then
  GOVUK_APP_DOMAIN=www.gov.uk \
  GOVUK_WEBSITE_ROOT=https://www.gov.uk \
  PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://govuk-content-store-examples.herokuapp.com/api} \
  PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.publishing.service.gov.uk} \
  PLEK_SERVICE_RUMMAGER_URI=${PLEK_SERVICE_RUMMAGER_URI-https://www.gov.uk/api} \
  bundle exec foreman run web
else
  bundle exec foreman run web
fi
