# Disclosure Checker MVP

This is a Rails application to enable citizens to check when their convictions are spent.  
It is based on software patterns developed for the [C100 Application][c100-application].

## Getting Started

* Copy `.env.example` to `.env` and replace with suitable values.  

* `bundle install`
* `bundle exec rails db:setup`
* `bundle exec rails db:migrate`
* `bundle exec rails server`

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
