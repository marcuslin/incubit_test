# README

* Ruby version: `3.0.1`
* Rails version: `6.1.4`
* Database: Postgresql

## Clone project
* Execute `git clone https://github.com/marcuslin/incubit_test.git` in your console,
and the directory you want to place this project

## Setting up environment
* Install gems by executing `bundle` in console under project directory

* Rename databse.example.yml
Rename both these files by executing the command below:
```
mv config/database.example.yml config/database.yml
```

## Create database
* Update database user and password inside `.env`
```
DB_USERNAME=<Your db user>
DB_PASSWORD=<Your db password>
```
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
bundle exec rspec ./spec
```
