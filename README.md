# Rails Driver

This application is part of the [Rails Engine](https://backend.turing.io/module3/projects/rails_engine) project for the Turing School of Software and Design.

It includes

1. A Test Suite for Rails Engine
1. A Front End for Rails Engine

## Set Up

First clone the repository and then run the following commands:

1. `bundle` (if this fails, try to `bundle update` and then retry)
1. `rails db:create && rails db:migrate`
1. `bundle exec figaro install`

This last command should create the file `config/application.yml`. Open this file and add configuration for the Environment variable `RAILS_ENGINE_DOMAIN`. This should be the url from where Rails Engine is being served. You are only using Rails Driver locally, append this to `config/application.yml`:

```
RAILS_ENGINE_DOMAIN: http://localhost:3000
```

## Test Suite

`spec/features/harness_spec.rb` includes tests for the Rails Engine Project. In order for this test suite to run properly, you will need to:

1. Make sure your Rails Engine Database is seeded with the original data from the provided csv files
1. Make sure Rails Engine is serving from the url you specified in `config/application.yml` (`localhost:3000` if you copied 
the example `config/application.yml` above)

## Front End

You can also use the Front End to test Rails Engine. The Front End is an example of how your Rails Engine API could be consumed. If you are running Rails Engine on `localhost:3000` as in the examples above, you will need to run Rails Driver on a different port, for example:

```
rails s -p 3001
```

Navigate your browser to `localhost:3001` to see Rails Driver in action.

If you are just starting the project, you should see an empty Item index.
