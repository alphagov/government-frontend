# Government Frontend

Government Frontend is a public-facing app to display the majority of documents
on the /government part of GOV.UK. It is a replacement for the public-facing
parts of the [Whitehall](https://github.com/alphagov/whitehall) application.

## Schemas

Not all schemas that this app can handle are rendered by it in production.

| Schema | Live example | Production status |
|---|---|---|
| Answer | [View on GOV.UK](https://www.gov.uk/national-minimum-wage-rates) | Migrated |
| Case study | [View on GOV.UK](https://www.gov.uk/government/case-studies/2013-elections-in-swaziland) | Migrated |
| Coming soon |  | Migrated |
| Consultation | [View on GOV.UK](https://www.gov.uk/government/consultations/soft-drinks-industry-levy) | Migrated |
| Contacts | [View on GOV.UK](https://www.gov.uk/government/organisations/hm-revenue-customs/contact/alcohol-duties-national-registration-unit) | Migrated |
| Corporate information page | [View on GOV.UK](https://www.gov.uk/government/organisations/government-digital-service/about) | Migrated |
| Detailed guide | [View on GOV.UK](https://www.gov.uk/guidance/waste-exemption-nwfd-2-temporary-storage-at-the-place-of-production--2) | Migrated |
| Document collection | [View on GOV.UK](https://www.gov.uk/government/collections/statutory-guidance-schools) | Migrated |
| Fatality notice | [View on GOV.UK](https://www.gov.uk/government/fatalities/corporal-lee-churcher-dies-in-iraq) | Migrated |
| Help page | [View on GOV.UK](https://www.gov.uk/help/about-govuk) | Migrated |
| HTML Publication | [View on GOV.UK](https://www.gov.uk/government/publications/budget-2016-documents/budget-2016)| Migrated |
| News Article | [View on GOV.UK](https://www.gov.uk/government/news/the-personal-independence-payment-amendment-regulations-2017-statement-by-paul-gray) | Migrated |
| Publication | [View on GOV.UK](https://www.gov.uk/government/publications/budget-2016-documents) | Migrated |
| Specialist document | [View on GOV.UK](https://www.gov.uk/business-finance-support/access-to-finance-advice-north-west-england) | Migrated
| Statistics announcement | [View on GOV.UK](https://www.gov.uk/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015) | Migrated |
| Statistical data set | [View on GOV.UK](https://www.gov.uk/government/statistical-data-sets/unclaimed-estates-list) | Migrated |
| Speech | [View on GOV.UK](https://www.gov.uk/government/speeches/government-at-your-service-ben-gummer-speech) | Migrated |
| Take part | [View on GOV.UK](https://www.gov.uk/government/get-involved/take-part/become-a-councillor) | Migrated |
| Topical event about page | [View on GOV.UK](https://www.gov.uk/government/topical-events/2014-overseas-territories-joint-ministerial-council/about) | Migrated |
| Travel advice | [View on GOV.UK](https://www.gov.uk/foreign-travel-advice/nepal) | Migrated |
| Unpublishing | | Rendered by Whitehall, might not be migrated |
| World Location News Article | [View on GOV.UK](https://www.gov.uk/government/world-location-news/changes-to-secure-english-language-test-providers-for-uk-visas) | Migrated |
| Working group | [View on GOV.UK](https://www.gov.uk/government/groups/abstraction-reform) | Migrated |

## Components

Pages are rendered using components. Components can be specific to government-frontend or shared between applications.

Shared components are provided by govuk_publishing_components and are documented in the [component guide](https://components.publishing.service.gov.uk/component-guide).

Components specific to government-frontend are [within the application](https://github.com/alphagov/government-frontend/tree/master/app/views/components) and follow rules set out by the [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components) gem. They are documented in the [government-frontend component guide](https://government-frontend.herokuapp.com/component-guide).

When [running government-frontend](#running-the-application) locally the component guide is available at: http://government-frontend.dev.gov.uk/component-guide

Configuration for the navigation links shown on the B variant of the ContentPagesNav A/B test is covered [separately](docs/navigation-links.md)

## Technical documentation

This is a Ruby on Rails application that fetches documents from
[content-store](https://github.com/alphagov/content-store) and displays them.

### Dependencies

- [content-store](https://github.com/alphagov/content-store) - provides documents
- [static](https://github.com/alphagov/static) - provides shared GOV.UK assets and templates.
- [phantomjs](http://phantomjs.org/) Used by poltergeist for integration testing
- [ImageMagick](http://brewformulas.org/Imagemagick) Used by Wraith for visual regression testing

### Running the application

```
./startup.sh
```

The app should start on http://localhost:3090 or
http://government-frontend.dev.gov.uk on GOV.UK development machines.

```
./startup.sh --live
```

This will run the app and point it at the production GOV.UK `content-store` and `static` instances.

```
./startup.sh --dummy
```

This will run the app and point it at the [dummy content store](https://govuk-content-store-examples.herokuapp.com/), which serves the content schema examples and random content.

### Running the test suite

The test suite relies on the presence of the
[govuk-content-schemas](http://github.com/alphagov/govuk-content-schemas)
repository. If it is present at the same directory level as
the government-frontend repository then run the tests with:

`bundle exec rake`

Or to specify the location explicitly:

`GOVUK_CONTENT_SCHEMAS_PATH=/some/dir/govuk-content-schemas bundle exec rake`

#### Debugging Integration tests
If you want to see the page that is being tested in our integration tests, you can use
`save_and_open_page` to see what's rendered. This is helpful when a page is mostly comprised of
GOV.UK Publishing Components

### Further documentation

- [Visual regression tests](docs/visual-regression-tests.md)

## Webchat

### How to add a new webchat provider
1. Open to `lib/webchat.yaml`
2. Append new entry:
```yaml
- base_path: /government/contact/my-amazing-service
  open_url: https://www.my-amazing-webchat.com/007/open-chat
  availability_url: https://www.my-amazing-webchat.com/007/check-availability
```

3. Deploy changes
4. Go to https://www.gov.uk/government/contact/my-amazing-service
5. Finished

### CORS considerations
To avoid CORS and CSP issues a new provider would need to be added to the Content Security Policy

### Required configuration

#### Base path
This is the base path of a contact page, for example, `/government/organisations/hm-revenue-customs/contact/child-benefit`.
This path should always be a contact page, any other content page type will result in the webchat component not being loaded.

#### Availability URL
This URL is used to check the availability of agents at regular intervals.

|  Function  |  Required |
|-----------|-----------|
| Request Method  | GET  |
| Response Format | JSON/JSONP (Default to JSONP) |
| Request Example | {"status":"success","response":"BUSY"}  |
| Valid statuses | ["BUSY", "UNAVAILABLE", "AVAILABLE","ONLINE", "OFFLINE", "ERROR"] |

#### Open URL
This url is used to start a webchat session.
This url should not include session ids or require anything specific parameters to be generated.

### Optional Configuration options

#### Browser window behaviour
By default the chat session would open in an a separate browser window. An additional value can be added to the yaml entry that will allow the web chat to remain in the current browser window.
```yaml
  open_url_redirect: true
```
#### Payload format

The default response from the api as used by HMRC webchat provider is JSONP. To add a provider that responds using JSON the following entry needs to be added.
```yaml
  availability_payload_format: json
```

## Licence

[MIT License](LICENCE)
