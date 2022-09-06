#!/bin/bash

bundle install

function set_env() {
  export GOVUK_APP_DOMAIN=www.$1
  export GOVUK_WEBSITE_ROOT=https://www.$1
  export PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://test:bla@www.$1/api}
  export PLEK_SERVICE_RUMMAGER_URI=${PLEK_SERVICE_RUMMAGER_URI-https://www.$1/api}
  export PLEK_SERVICE_SEARCH_URI=${PLEK_SERVICE_SEARCH_URI-https://www.$1/api}
}

if [[ $1 == "--live" ]] ; then
  set_env "gov.uk"
  export GOVUK_PROXY_STATIC_ENABLED=true
  export PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.publishing.service.gov.uk}
else
  echo "ERROR: other startup modes are not supported"
  echo ""
  echo "https://docs.publishing.service.gov.uk/manual/local-frontend-development.html"
  exit 1
fi

bundle exec rails s -p 3090
