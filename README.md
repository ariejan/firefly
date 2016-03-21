# Firefly

Firefly is an elegant solution for personal media hosting and URL
shortening. Firefly 2 is a complete rewrite of the original project.

## Getting started

Trying out Firefly is pretty straightforward. You will need to have
Ruby (2.2 or better) installed.

### Get Firefly 2

    git clone https://github.com/ariejan/firefly.git
    cd firefly

### Install dependencies

    bundle install

### Create and migrate the Sqlite3 database

Firefly 2 is currently tested to work with sqlite. Support for other
databases is welcome. The following will initialize a sqlite database
in `db/firefly_development.sqlite`.

    hanami db create
    hanami db migrate

### Run the server

    hanami server

This will start hanami in development mode, using a local Sqlite 
database for storage. Open [http://localhost:2300/admin](http://localhost:2300/admin) 
and sign in with the development credentials: `admin` / `admin`.

## Running tests

Firefly 2 is fully tested using Minitest. Running tests should be 
easy and straightforward:

    HANAMI_ENV=test hanami db prepare
    rake test

## Current status

[![Build Status](https://secure.travis-ci.org/ariejan/firefly.png?branch=master)](https://travis-ci.org/ariejan/firefly)

Firefly 2 is still a work in progress. It's stable, but not yet feature
complete and currently _unreleased_. You are free to use and play 
with `HEAD`, but do so at your own risk (e.g. make backups).

## How to help

Your help is welcome! Check out the open list of [issues](https://github.com/ariejan/firefly/issues) to
see what features and bugs are currently open, or open a 
[new issue](https://github.com/ariejan/firefly/issues/new) to discuss your own ideas. 

[Pull requests](https://github.com/ariejan/firefly/pulls) are very welcome! 

## Code of Conduct

Be nice and respectful. 

## License

This project is licensed under the [MIT Licence](https://github.com/ariejan/firefly/blob/master/LICENSE.md).

## Contributors

This project was written by [Ariejan de Vroom](https://ariejan.net) and [a cool gang of contributors](https://github.com/ariejan/firefly/graphs/contributors)
