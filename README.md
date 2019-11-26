# Government Frontend

Government Frontend is a public-facing app to display the majority of documents
on the /government part of GOV.UK. It is a replacement for the public-facing
parts of the [Whitehall](https://github.com/alphagov/whitehall) application.

## Screenshots

![A Case Study](https://raw.githubusercontent.com/alphagov/government-frontend/master/docs/assets/case-study-screenshot.png)

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

Shared components are provided by static and are documented in the [static component guide](https://govuk-static.herokuapp.com/component-guide).

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

### Visual regression tests

Use [Wraith](http://bbc-news.github.io/wraith/) ("A responsive screenshot
comparison tool") to generate a visual diff to compare rendering changes in this
application.

#### Compare with production

Compare development with production:
```
bundle exec wraith capture test/wraith/config.yaml
```

Compare staging with production:
```
bundle exec wraith capture test/wraith/config-staging-vs-production.yaml
```

This will generate image diffs comparing the two runs, including a browsable
gallery of the output, located at `shots/gallery.html`.


#### Compare examples on master with examples on branch

Examples are referencing https://github.com/alphagov/govuk-content-schemas

With government-frontend running master on the development VM and while [pointing at the dummy content store](https://github.com/alphagov/govuk-content-schemas/blob/master/docs/running-frontend-against-examples.md), create a set of historical screenshots using:
```
cd test/wraith
bundle exec wraith history test/wraith/config-examples.yaml
```

Then switch to your branch and create a set of screenshots to compare against using:
```
bundle exec wraith latest test/wraith/config-examples.yaml
```

#### Compare a document_type

A rake task has been made to make this easy, given a `document_type` of `about`

```
bundle exec rake wraith:document_type[about]
```

this will run against the 10 most popular pages as defined by the search api

#### Compare all document_types

```
bundle exec rake wraith:all_document_types[:sample_size]
```

This will run against the 10 (can be overidden with `:sample_size`) most popular pages as defined by the search api,
for each known `document_type` in the app (see: [Generate a config for known document_types and example pages](#generate-a-config-for-known-document_types-and-example-pages)).

*Note:* If you wish to have your own local wip configs, wip* is in the .gitignore, so as an example
`wip-kittens.yaml` will be ignored

#### Generate a config for known document_types and example pages

Running the rake task below will retrieve the `document_types` where `rendering_app = government-frontend` from the search api. It will then generate `test/wraith/wip-config-all-document-types.yaml`, this is a wraith config file containing the top 10 (can be overidden with `:sample_size`) example pages for each type.

The yaml file contains a custom key of `:document_types` not used by wraith but can be used to quickly scan and see which types the search api believes `government-frontend` is responsible for.

```
bundle exec rake wraith:update_document_types[:sample_size]
```

## Licence

[MIT License](LICENCE)
