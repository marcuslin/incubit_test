# README

* Ruby version: `3.0.1`
* Rails version: `6.1.4`
* Database: Postgresql

## Clone project
* Execute `git clone git@github.com:marcuslin/incubit_assessment.git` in your console,
and the directory you want to place this project

## Setting up environment
* Install gems by executing `bundle` in console under project directory

* Rename both databse.example.yml and secrets.example.yml
Rename both these files by executing the command below:
```
mv config/database.example.yml config/database.yml
mv config/secrets.example.yml config/secrets.yml
```

## Create database
* Execute the command below to create both development and test db
```
rails db:create
```

* Execute the command below for db migration
```
rails db:migrate
```

## Test
* Execute the commad below to run all tests in console
```
rspec spec/
```

* For running specific test execute the command below in console
```
rspec spec/{ test_type }/{ filename }_spec.rb
```

* Note: For this project, `test_type` will only be `models` and `requests`

