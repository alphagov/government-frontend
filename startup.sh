#!/bin/bash

bundle install

function set_env() {
  export GOVUK_APP_DOMAIN=www.$1
  export GOVUK_WEBSITE_ROOT=https://www.$1
  export PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://test:bla@www.$1/api}
  export PLEK_SERVICE_SEARCH_API_URI=${PLEK_SERVICE_SEARCH_API_URI-https://www.$1/api}
}

if [[ $1 == "--live" ]] ; then
  set_env "gov.uk"
  export GOVUK_PROXY_STATIC_ENABLED=true
  export PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-http://static.dev.gov.uk}
  ./bin/dev
else
  echo "ERROR: other startup modes are not supported"
  echo ""
  echo "https://docs.publishing.service.gov.uk/manual/local-frontend-development.html"
  exit 1
fi
