# FireFly [![Build Status](https://secure.travis-ci.org/ariejan/firefly.png?branch=master)](http://travis-ci.org/ariejan/firefly)

FireFly is a simple URL shortener for personal (or not so personal) use.

## About Firefly 2.0

Firefly 2.0 is a complete rewrite of the original Firefly URL shortener.

Some features that 2.0 will sport:

 * Fully ruby 1.9 compatible.
 * Easy to install and upgrade.
 * Support for postgres, sqlite3 and mysql.
 * Better documentation.

Among those features there are also some other significant changes:

 * No longer a gem, just a plain Rack application.

If you're looking to have a working install of Firefly, use the
[latest 1.5.3 version][1-5-stable].

The `master` branch contains the next version, 2.0.0-pre, of Firefly and is
not suitable for any kind of serious use at this time.

## Installation

### Get the code

Installation _should_ be as easy as:

    git clone https://github.com/ariejan/firefly.git mydomain
    cd mydomain

### Configuration

Then, put the configuration in place:

    cp config/database.example.yml config/database.yml
    cp config/firefly.example.yml config/firefly.yml

Before you edit these, open up `Gemfile` and comment out the database
gems you don't need. So, if you want to use Postgres, comment out
the `mysql2` and `sqlite3` gems, like so:

    gem 'pg'
    # gem 'mysql2'
    # gem 'sqlite3'

Next, open up `config/database.yml` and `config/firefly.yml` and configure
everything according to your needs.

### Bundle

Run `bundle install` to install all gem dependencies.

### Create your database

#### Postgres

Just create a new database:

    psql -c 'create database firefly_test;'

#### MySQL

Make sure to create a database that uses the `utf8` character set and
`utf8_bin` collation. This is to ensure MySQL can lookup case sensitive strings.

    mysql -e 'create database firefly_test character set utf8 collate utf8_bin;'

#### Sqlite3

Nothing special to do here.

### Run migrations

    rake db:migrate

### Start your Firefly

    rackup

## Supported rubies

The entire spec suite is run against the latest ruby-1.9.2 and ruby-1.9.3. These
are the officially supported rubies.

The spec suite is also run against Rubinius in 1.9-mode and ruby-head. Although
I strife to get these builds passing, they are not officially supported by me at
this time.

jruby, ruby-1.8.x and others are currently not supported.

## Deployments to Heroku

Heroku is a popular deploy target and is fully supported by Firefly. There's
nothing holding you back from deploying to Heroku, except that the 
`config/database.yml` and `config/firefly.yml` files a currently ignored by git.

Edit, `.gitignore` and remove the entries for these files, commit your changes
and push to Heroku.

## Development

I develop against Postgres and have Travis run the specs against MySQL and
sqlite3. 

To get your own environment setup, follow the installation guide, with the 
following twist:

 * Don't comment out the database gems. If you can't or don't want to install
database specific gems, feel free to comment them out, but don't ever commit
these changes

Then you should be able to run the spec suite like so:

    RACK_ENV=test rake

## Background

Firefly was started in 2009 as side project to dive into the world of URL
shorteners. I've been using Firefly since then for my own domain and many 
others have joined me.

After writing the last 1.5.x release in 2011 I kind of forgot about Firefly.
Nearing the end of 2012 I picked it up again and I'm now in the process of
dusting of the cobwebs and giving Firefly a nice make-over.

## Note on Patches, Pull Requests and Issues

If you encounter an issue with Firefly, please feel free to create an issue
in [Github Issues][issues].

In case you want to contribute, fork the project, create a feature or
bugfix branch and sen in a pull request.

*I prefer pull requests with only added failing specs over a pull request
with working code and no specs.*

## Credits

**Author**: Ariejan de Vroom
**URL**: [http://ariejan.net][ariejannet]

## License

See [LICENSE][license] for more information.

[issues]: https://github.com/ariejan/firefly/issues
[1-5-stable]: https://github.com/ariejan/firefly/tree/1-5-stable
[ariejannet]: http://ariejan.net
[license]: https://github.com/ariejan/firefly/blob/master/LICENSE
