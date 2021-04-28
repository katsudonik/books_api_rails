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

- authorize custom actions
    - use `authenticate_user!`
        ```
        class ExamplesController < ApplicationController
        before_action :authenticate_user!
        ```
    - before sign in:
        ```
        $ curl localhost:3000/examples -X POST -d '{"title": "title_example", "body": "body_example"}' -H "content-type:application/json" -H "uid: example@example.com" -H "client: I_y-d1XShfJdSe8utjebwg" -H "access-token: 6QIzZnfBzNG366P_lQHtcg" -i

        HTTP/1.1 401 Unauthorized
        Content-Type: application/json; charset=utf-8
        Cache-Control: no-cache
        X-Request-Id: dfb3a9a6-473a-4756-b5a4-53196fa8fc59
        X-Runtime: 0.005292
        Transfer-Encoding: chunked

        {"errors":["You need to sign in or sign up before continuing."]}
        ```
    - after sign in:
        ```
        $ curl localhost:3000/books -X POST -d '{"title": "title_example", "body": "body_example"}' -H "content-type:application/json" -H "uid: example@example.com" -H "client: ZnW1ki2pDwxG3eiQpvWMng" -H "access-token: dRyEKdjdqXp8bVgFxG_4uw" -i

        HTTP/1.1 201 Created
        Location: http://localhost:3000/books/2
        Content-Type: application/json; charset=utf-8
        access-token: WoalM1CYOUzUnxk94oAtMg
        token-type: Bearer
        client: ZnW1ki2pDwxG3eiQpvWMng
        expiry: 1620788907
        uid: example@example.com
        ETag: W/"acf78800c907f89d4928e86d1dc9b992"
        Cache-Control: max-age=0, private, must-revalidate
        X-Request-Id: 56c04c87-951b-4f52-aa4d-aab9ae285dc2
        X-Runtime: 0.131501
        Transfer-Encoding: chunked

        {"id":2,"title":"title_example","body":"body_example","user":{"id":1,"provider":"email","uid":"example@example.com","allow_password_change":false,"name":null,"nickname":null,"image":null,"email":"example@example.com","created_at":"2021-04-28T02:39:38.000Z","updated_at":"2021-04-28T03:07:58.000Z"}}
        ```

- ref: https://devise-token-auth.gitbook.io/devise-token-auth/config
