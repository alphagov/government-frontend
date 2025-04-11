# Government Frontend

Government Frontend is a public-facing app to display the majority of documents on the /government part of GOV.UK, which are fetched from the [Content Store](https://github.com/alphagov/content-store). It is a replacement for the public-facing parts of the [Whitehall](https://github.com/alphagov/whitehall) application.

## Schemas

| Schema | Live example |
|---|---|
| Answer | [View on GOV.UK](https://www.gov.uk/national-minimum-wage-rates) |
| Call for evidence | [View on GOV.UK](https://www.gov.uk/government/calls-for-evidence/local-air-quality-management-public-authorities-call-for-evidence) |
| Case study | [View on GOV.UK](https://www.gov.uk/government/case-studies/2013-elections-in-swaziland) |
| Consultation | [View on GOV.UK](https://www.gov.uk/government/consultations/soft-drinks-industry-levy) |
| Contacts | [View on GOV.UK](https://www.gov.uk/government/organisations/hm-revenue-customs/contact/alcohol-duties-national-registration-unit) |
| Corporate information page | [View on GOV.UK](https://www.gov.uk/government/organisations/government-digital-service/about) |
| Detailed guide | [View on GOV.UK](https://www.gov.uk/guidance/waste-exemption-nwfd-2-temporary-storage-at-the-place-of-production--2) |
| Document collection | [View on GOV.UK](https://www.gov.uk/government/collections/statutory-guidance-schools) |
| Fatality notice | [View on GOV.UK](https://www.gov.uk/government/fatalities/corporal-lee-churcher-dies-in-iraq) |
| Field of operation | [View on GOV.UK](https://www.gov.uk/government/fields-of-operation/iraq) |
| HTML Publication | [View on GOV.UK](https://www.gov.uk/government/publications/budget-2016-documents/budget-2016)|
| Guide | [View on GOV.UK](https://www.gov.uk/log-in-register-hmrc-online-services)|
| News Article | [View on GOV.UK](https://www.gov.uk/government/news/the-personal-independence-payment-amendment-regulations-2017-statement-by-paul-gray) |
| Publication | [View on GOV.UK](https://www.gov.uk/government/publications/budget-2016-documents) |
| Specialist document | [View on GOV.UK](https://www.gov.uk/business-finance-support/access-to-finance-advice-north-west-england) |
| Statistics announcement | [View on GOV.UK](https://www.gov.uk/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015) |
| Statistical data set | [View on GOV.UK](https://www.gov.uk/government/statistical-data-sets/unclaimed-estates-list) |
| Speech | [View on GOV.UK](https://www.gov.uk/government/speeches/government-at-your-service-ben-gummer-speech) |
| Topical event about page | [View on GOV.UK](https://www.gov.uk/government/topical-events/2014-overseas-territories-joint-ministerial-council/about) |
| Working group | [View on GOV.UK](https://www.gov.uk/government/groups/abstraction-reform) |
| Worldwide corporate information page | [View on GOV.UK](https://www.gov.uk/world/organisations/british-embassy-madrid/about/complaints-procedure) |
| Worldwide office | [View on GOV.UK](https://www.gov.uk/world/organisations/british-embassy-paris/office/british-embassy) |
| Worldwide organisation | [View on GOV.UK](https://www.gov.uk/world/organisations/british-embassy-madrid) |

## Technical documentation

This is a Ruby on Rails app, and should follow [our Rails app conventions](https://docs.publishing.service.gov.uk/manual/conventions-for-rails-applications.html).

You can use the [GOV.UK Docker environment](https://github.com/alphagov/govuk-docker) or the local `startup.sh` script to run the app. Read the [guidance on local frontend development](https://docs.publishing.service.gov.uk/manual/local-frontend-development.html) to find out more about each approach, before you get started.

If you are using GOV.UK Docker, remember to combine it with the commands that follow. See the [GOV.UK Docker usage instructions](https://github.com/alphagov/govuk-docker#usage) for examples.

### Running the test suite

```
bundle install
yarn install
bundle exec rake
```

### Components

Pages are rendered using components. Components can be specific to government-frontend or shared between applications.

Components specific to government-frontend are [within the application](https://github.com/alphagov/government-frontend/tree/master/app/views/components) and follow rules set out by the [govuk_publishing_components](https://github.com/alphagov/govuk_publishing_components) gem. They are documented in the [government-frontend component guide](https://government-frontend.herokuapp.com/component-guide).

### Further documentation

- [Webchat](docs/webchat.md)

## Licence

[MIT License](LICENCE)
