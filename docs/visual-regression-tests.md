# Visual regression tests

Use [Wraith](http://bbc-news.github.io/wraith/) ("A responsive screenshot comparison tool") to generate a visual diff to compare rendering changes in this application. [ImageMagick](http://brewformulas.org/Imagemagick) is needed to run the visual regression tests locally.

## Compare with production

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


## Compare examples on master with examples on branch

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

## Compare a document_type

A rake task has been made to make this easy, given a `document_type` of `about`

```
bundle exec rake wraith:document_type[about]
```

this will run against the 10 most popular pages as defined by the search api

## Compare all document_types

```
bundle exec rake wraith:all_document_types[:sample_size]
```

This will run against the 10 (can be overidden with `:sample_size`) most popular pages as defined by the search api,
for each known `document_type` in the app (see: [Generate a config for known document_types and example pages](#generate-a-config-for-known-document_types-and-example-pages)).

*Note:* If you wish to have your own local wip configs, wip* is in the .gitignore, so as an example
`wip-kittens.yaml` will be ignored

## Generate a config for known document_types and example pages

Running the rake task below will retrieve the `document_types` where `rendering_app = government-frontend` from the search api. It will then generate `test/wraith/wip-config-all-document-types.yaml`, this is a wraith config file containing the top 10 (can be overidden with `:sample_size`) example pages for each type.

The yaml file contains a custom key of `:document_types` not used by wraith but can be used to quickly scan and see which types the search api believes `government-frontend` is responsible for.

```
bundle exec rake wraith:update_document_types[:sample_size]
```
