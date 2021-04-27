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

## devise-token-auth

- create user
    ```
    $ curl localhost:3000/auth -X POST -d '{"email":"example@example.com", "password":"password", "password_confirmation": "password"}' -H "content-type:application/json"
    {"status":"success","data":{"uid":"example@example.com","id":1,"email":"example@example.com","provider":"email","allow_password_change":false,"name":null,"nickname":null,"image":null,"created_at":"2021-04-27T13:09:03.000Z","updated_at":"2021-04-27T13:09:03.000Z"}}
    ```
- sign in
    ```
    $ curl localhost:3000/auth/sign_in -X POST -d '{"email":"example@example.com", "password":"password"}' -H "content-type:application/json" -i
    HTTP/1.1 200 OK
    Content-Type: application/json; charset=utf-8
    access-token: 6QIzZnfBzNG366P_lQHtcg
    token-type: Bearer
    client: I_y-d1XShfJdSe8utjebwg
    expiry: 1620738587
    uid: example@example.com
    ETag: W/"0b844d681927a23677ff78329b4c7409"
    Cache-Control: max-age=0, private, must-revalidate
    X-Request-Id: 3cd38ac5-1925-4498-b488-973b60b189c7
    X-Runtime: 0.310815
    Transfer-Encoding: chunked

    {"data":{"id":1,"email":"example@example.com","provider":"email","uid":"example@example.com","allow_password_change":false,"name":null,"nickname":null,"image":null}}
    ```

- change password (using access_token)
    ```
    $ curl localhost:3000/auth/password -X PUT -d '{"password":"password_new", "password_confirmation": "password_new"}' -H "content-type:application/json" -H "access-token: 6QIzZnfBzNG366P_lQHtcg" -H "client: I_y-d1XShfJdSe8utjebwg" -H "uid: example@example.com"
    {"success":true,"data":{"id":1,"provider":"email","allow_password_change":false,"email":"example@example.com","uid":"example@example.com","name":null,"nickname":null,"image":null,"created_at":"2021-04-27T13:09:03.000Z","updated_at":"2021-04-27T13:11:15.000Z"},"message":"Your password has been successfully updated."}
    ```

- ref: https://devise-token-auth.gitbook.io/devise-token-auth/config



