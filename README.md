
Firefly is an elegant solution for personal media hosting and URL
shortening. Firefly 2 is a complete rewrite of the original project.

# Current status

[![Travis](https://img.shields.io/travis/ariejan/firefly.svg?style=flat-square)](https://travis-ci.org/ariejan/firefly) [![Gemnasium](https://img.shields.io/gemnasium/ariejan/firefly.svg?style=flat-square)](https://gemnasium.com/ariejan/firefly) [![Coveralls](https://img.shields.io/coveralls/ariejan/firefly.svg?style=flat-square)](https://coveralls.io/github/ariejan/firefly?branch=master) [![Code Climate](https://img.shields.io/codeclimate/github/ariejan/firefly.svg?style=flat-square)](https://codeclimate.com/github/ariejan/firefly) [![Gitter](https://img.shields.io/gitter/room/ariejan/firefly.svg?style=flat-square)](https://gitter.im/ariejan/firefly) ![Made in Holland](https://img.shields.io/badge/made%20in-holland-orange.svg?style=flat-square)

Firefly 2 is still a work in progress. It's stable, but not yet feature
complete and currently _unreleased_. You are free to use and play 
with `HEAD`, but do so at your own risk (e.g. make backups).

# Getting started

Firefly is a modern ruby web application. The following you 
will need:

 * Ruby 2.2 or 2.3, we suggest using [rbenv](https://github.com/rbenv/rbenv)
 * Redis, see your system's package manager
 * Foreman, `gem install foreman`

## Get Firefly 2

    git clone https://github.com/ariejan/firefly.git
    cd firefly

## Install dependencies

    bundle install

## Create and migrate the Sqlite3 database

Firefly 2 is currently tested to work with sqlite. Support for other
databases is welcome. The following will initialize a sqlite database
in `db/firefly_development.sqlite`.

    hanami db create
    hanami db migrate
    
## Start redis server

If your system is not running redis out of the box as a service, you should
start it manually (do this in a separate terminal):

    redis-server

## Run Firefly

    foreman start

This will start hanami in development mode, using a local Sqlite 
database for storage. It will also start a Sidekiq worker for
asynchronously processing data (like links and images).d

Open [http://localhost:2300/admin](http://localhost:2300/admin) 
and sign in with the development credentials: `admin` / `admin`.

# Running tests

Firefly 2 is fully tested using Minitest. Running tests should 
alwasy be easy and straightforward:

    HANAMI_ENV=test hanami db prepare
    rake test

# How to contribute

Your help is welcome! 

Check out the open list of [issues](https://github.com/ariejan/firefly/issues) to
see what features and bugs are currently open. If you're just starting out with Ruby
and/or Hanami, check out the [beginner friendly](https://github.com/ariejan/firefly/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aopen+label%3A%22beginner+friendly%22) issues, which are great for warming up your skills. 

Feel free to open a 
[new issue](https://github.com/ariejan/firefly/issues/new) to discuss your own ideas, or a [pull request](https://github.com/ariejan/firefly/pulls) if you've already got something to show.

If you need any help, please hop by on [Gitter](https://gitter.im/ariejan/firefly) to chat.

# Contributor Covenant Code of Conduct

## Our Pledge

In the interest of fostering an open and welcoming environment, we as
contributors and maintainers pledge to making participation in our project and
our community a harassment-free experience for everyone, regardless of age, body
size, disability, ethnicity, gender identity and expression, level of experience,
nationality, personal appearance, race, religion, or sexual identity and
orientation.

## Our Standards

Examples of behavior that contributes to creating a positive environment
include:

* Using welcoming and inclusive language
* Being respectful of differing viewpoints and experiences
* Gracefully accepting constructive criticism
* Focusing on what is best for the community
* Showing empathy towards other community members

Examples of unacceptable behavior by participants include:

* The use of sexualized language or imagery and unwelcome sexual attention or
advances
* Trolling, insulting/derogatory comments, and personal or political attacks
* Public or private harassment
* Publishing others' private information, such as a physical or electronic
  address, without explicit permission
* Other conduct which could reasonably be considered inappropriate in a
  professional setting

## Our Responsibilities

Project maintainers are responsible for clarifying the standards of acceptable
behavior and are expected to take appropriate and fair corrective action in
response to any instances of unacceptable behavior.

Project maintainers have the right and responsibility to remove, edit, or
reject comments, commits, code, wiki edits, issues, and other contributions
that are not aligned to this Code of Conduct, or to ban temporarily or
permanently any contributor for other behaviors that they deem inappropriate,
threatening, offensive, or harmful.

## Scope

This Code of Conduct applies both within project spaces and in public spaces
when an individual is representing the project or its community. Examples of
representing a project or community include using an official project e-mail
address, posting via an official social media account, or acting as an appointed
representative at an online or offline event. Representation of a project may be
further defined and clarified by project maintainers.

## Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported by contacting the project team at ariejan@ariejan.net ([GPG](https://ariejan.net/gpg/)) or opening
an [issue](https://github.com/ariejan/firefly/issues). All
complaints will be reviewed and investigated and will result in a response that
is deemed necessary and appropriate to the circumstances. The project team is
obligated to maintain confidentiality with regard to the reporter of an incident.
Further details of specific enforcement policies may be posted separately.

Project maintainers who do not follow or enforce the Code of Conduct in good
faith may face temporary or permanent repercussions as determined by other
members of the project's leadership.

## Attribution

This Code of Conduct is adapted from the [Contributor Covenant][homepage], version 1.4,
available at [http://contributor-covenant.org/version/1/4][version]

[homepage]: http://contributor-covenant.org
[version]: http://contributor-covenant.org/version/1/4/

# Contributors

This project was written by [Ariejan de Vroom](https://ariejan.net) and [a cool gang of contributors](https://github.com/ariejan/firefly/graphs/contributors)

# License

This project is licensed under the [MIT Licence](https://github.com/ariejan/firefly/blob/master/LICENSE.md).
