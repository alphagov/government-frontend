#!/bin/bash

bundle install

function set_env() {
  export GOVUK_APP_DOMAIN=www.$1
  export GOVUK_WEBSITE_ROOT=https://www.$1
  export PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://test:bla@www.$1/api}
}

if [[ $1 == "--live" ]] ; then
  set_env "gov.uk"
  ./bin/dev
else
  echo "ERROR: other startup modes are not supported"
  echo ""
  echo "https://docs.publishing.service.gov.uk/manual/local-frontend-development.html"
  exit 1
fi
