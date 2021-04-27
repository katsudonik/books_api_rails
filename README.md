# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## parallel_rspec

### usage

1. Initial Setup (Create as many databases as there are processes available on the execution machine )
    ```
    bundle exec rake parallel:setup 
    ```

2. migration
    ```
    bundle exec rails db:migrate RAILS_ENV=development
    bundle exec rails db:migrate RAILS_ENV=test   
    ```

3. reflect migrate result
    ```
    bundle exec rake parallel:prepare 
    ```

4. run test
    ```
    bundle exec parallel_rspec spec
    ```

#### specify seed

```
bundle exec parallel_rspec spec --test-options '--seed 59268'
```

### failed log

output into `tmp/failing_specs.log`




