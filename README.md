# Government Frontend

Government Frontend is a public-facing app to display the majority of documents
on the /government part of GOV.UK. It is a replacement for the public-facing
parts of the [Whitehall](https://github.com/alphagov/whitehall) application.

## Screenshots

![A  Case Study](https://raw.githubusercontent.com/alphagov/government-frontend/master/docs/assets/case-study-screenshot.png)

## Live examples

- [gov.uk/government/case-studies/2013-elections-in-swaziland](https://www.gov.uk/government/case-studies/2013-elections-in-swaziland)
- [gov.uk/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015](https://www.gov.uk/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015)

## Technical documentation

This is a Ruby on Rails application that fetches documents from
[content-store](https://github.com/alphagov/content-store) and displays them.

### Dependencies

- [content-store](https://github.com/alphagov/content-store) - provides documents
- [static](https://github.com/alphagov/static) - provides shared GOV.UK assets and templates.

### Running the application

`./startup.sh`

The app should start on http://localhost:3090 or
http://government-frontend.dev.gov.uk on GOV.UK development machines.

### Running the test suite

The test suite relies on the presence of the
[govuk-content-schemas](http://github.com/alphagov/govuk-content-schemas)
repository. If it is present at the same directory level as
the government-frontend repository then run the tests with:

`bundle exec rake`

Or to specify the location explicitly:

`GOVUK_CONTENT_SCHEMAS_PATH=/some/dir/govuk-content-schemas bundle exec rake`

## Licence

[MIT License](LICENCE)
