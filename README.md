# Government Frontend

Government Frontend is a public-facing app to display the majority of documents
on the /government part of GOV.UK. It is a replacement for the public-facing
parts of the [Whitehall](https://github.com/alphagov/whitehall) application.

## Screenshots

![A  Case Study](https://raw.githubusercontent.com/alphagov/government-frontend/master/docs/assets/case-study-screenshot.png)

## Formats

Not all formats that this app can handle are rendered by it in production.

| Format | Live example | Production status |
|---|---|---|
| Case study | [View on GOV.UK](https://www.gov.uk/government/case-studies/2013-elections-in-swaziland) | Migrated |
| Coming soon | | Rendered by Whitehall |
| Consultation | | Rendered by Whitehall |
| Detailed guide | [View on GOV.UK](https://www.gov.uk/guidance/waste-exemption-nwfd-2-temporary-storage-at-the-place-of-production--2) | Migrated |
| Document collection | [View on GOV.UK](https://www.gov.uk/government/collections/statutory-guidance-schools) | Migrated on live. Draft rendered by Whitehall. |
| Fatality notice | [View on GOV.UK](https://www.gov.uk/government/fatalities/corporal-lee-churcher-dies-in-iraq) | Migrated |
| HTML Publication | | Rendered by Whitehall |
| Publication | | Rendered by Whitehall |
| Statistics announcement | [View on GOV.UK](https://www.gov.uk/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015) | Migrated |
| Statistical data set | [View on GOV.UK](https://www.gov.uk/government/statistical-data-sets/unclaimed-estates-list) | Migrated |
| Speech | | Rendered by Whitehall |
| Take part | [View on GOV.UK](https://www.gov.uk/government/get-involved/take-part/become-a-councillor) | Migrated |
| Topical event about page | [View on GOV.UK](https://www.gov.uk/government/topical-events/2014-overseas-territories-joint-ministerial-council/about) | Migrated |
| Unpublishing | | Rendered by Whitehall, might not be migrated |
| Working group | [View on GOV.UK](https://www.gov.uk/government/groups/2gether-nhs-foundation-trust) | Migrated |

## Technical documentation

This is a Ruby on Rails application that fetches documents from
[content-store](https://github.com/alphagov/content-store) and displays them.

### Dependencies

- [content-store](https://github.com/alphagov/content-store) - provides documents
- [static](https://github.com/alphagov/static) - provides shared GOV.UK assets and templates.

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

### Running the test suite

The test suite relies on the presence of the
[govuk-content-schemas](http://github.com/alphagov/govuk-content-schemas)
repository. If it is present at the same directory level as
the government-frontend repository then run the tests with:

`bundle exec rake`

Or to specify the location explicitly:

`GOVUK_CONTENT_SCHEMAS_PATH=/some/dir/govuk-content-schemas bundle exec rake`

### Visual regression tests

Use [Wraith](http://bbc-news.github.io/wraith/) ("A responsive screenshot
comparison tool") to generate a visual diff to compare rendering changes in this
application.

With government-frontend running on the [development VM](https://github.gds/gds/development), navigate to
the project directory and run
```
cd test/wraith
bundle install # only need to run this once to grab the dependencies
```

#### Compare with production

Compare development with production:
```
bundle exec wraith capture config.yaml
```

Compare staging with production:
```
bundle exec wraith capture config-staging-vs-production.yaml
```

This will generate image diffs comparing the two runs, including a browsable
gallery of the output, located at `test/wraith/shots/gallery.html`.

#### Compare examples on master with examples on branch

With government-frontend running master on the development VM and while [pointing at the dummy content store](https://github.com/alphagov/govuk-content-schemas/blob/master/docs/running-frontend-against-examples.md), create a set of historical screenshots using:
```
cd test/wraith
bundle exec wraith history config-examples.yaml
```

Then switch to your branch and create a set of screenshots to compare against using:
```
bundle exec wraith latest config-examples.yaml
```

### Adding a new format

There’s a rails generator you can use to stub the basic files needed for a new format. It stubs the following:
* Stylesheet
* Template
* Presenter
* Presenter test
* Integration test

```
bundle exec rails generate format [format_name]
```

## Licence

[MIT License](LICENCE)
