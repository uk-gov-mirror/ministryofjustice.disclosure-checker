# Check if you need to disclose your criminal record MVP

This is a Rails application to enable citizens to check when their convictions are spent.
It is based on software patterns developed for the [C100 Application][c100-application].

## Docker

The application can be run inside a docker container. This will take care of the ruby environment, postgres database, 
nginx, and any other dependency for you, without having to configure anything in your machine.

* `docker-compose up`

The application will be run in "production" mode, so will be as accurate as possible to a real production environment.  
An nginx reverse proxy will also be run to serve the static assets and to fallback to a static error page if the 
upstream server (rails with puma) does not respond.

Please note, in production environments this is done in a slightly different way as we don't use docker-compose in those 
environments (kubernetes cluster). But the general ideal is the same (nginx reverse proxy). 

## Getting Started

* Copy `.env.example` to `.env` and replace with suitable values.

* `bundle install`
* `bundle exec rails db:setup`
* `bundle exec rails db:migrate`
* `bundle exec rails server`

### GOV.UK Frontend (styles, javascript and other assets)

* `brew install yarn` # if you don't have it already
* `yarn` # this will install the dependencies

### For running the tests:

* Copy `.env.test.example` to `.env.test` and replace with suitable values if you expect to run the tests
* `RAILS_ENV=test bundle exec rails db:setup`
* `RAILS_ENV=test bundle exec rails db:migrate`

You can then run all the code linters and tests with:

* `RAILS_ENV=test bundle exec rake`
or
* `RAILS_ENV=test bundle exec rake test:all_the_things`

Or you can run specific tests as follows (refer to *lib/tasks/all_tests.rake* for the complete list):

* `RAILS_ENV=test bundle exec rake spec`
* `RAILS_ENV=test bundle exec rake brakeman`

## Cucumber features

Not yet implemented.

## K8s cluster staging environment

Not yet implemented.

## CircleCI and continuous deployment

Not yet implemented.

[c100-application]: https://github.com/ministryofjustice/c100-application
