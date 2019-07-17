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
  export PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.publishing.service.gov.uk}
elif [[ $1 == "--staging" ]] ; then
  set_env "staging.publishing.service.gov.uk"
  export PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.staging.publishing.service.gov.uk}
elif [[ $1 == "--integration" ]] ; then
  set_env "integration.publishing.service.gov.uk"
  export PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.integration.publishing.service.gov.uk}
elif [[ $1 == "--dummy" ]] ; then
  export GOVUK_APP_DOMAIN=www.gov.uk
  export GOVUK_WEBSITE_ROOT=https://www.gov.uk
  export PLEK_SERVICE_CONTENT_STORE_URI=${PLEK_SERVICE_CONTENT_STORE_URI-https://govuk-content-store-examples.herokuapp.com/api}
  export PLEK_SERVICE_STATIC_URI=${PLEK_SERVICE_STATIC_URI-assets.publishing.service.gov.uk}
  export PLEK_SERVICE_RUMMAGER_URI=${PLEK_SERVICE_RUMMAGER_URI-https://www.gov.uk/api}
  export PLEK_SERVICE_SEARCH_URI=${PLEK_SERVICE_SEARCH_URI-https://www.gov.uk/api}
fi

bundle exec rails s -p 3090
