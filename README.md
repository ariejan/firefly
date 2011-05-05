# FireFly [![Build Status](http://travis-ci.org/ariejan/firefly.png)](http://travis-ci.org/ariejan/firefly)


FireFly is a simple URL shortener for personal (or not so personal) use.

# Quick-Start (2 minutes) with Heroku

See the [screencast][1] or [written instructions][2] on how to setup Firefly within 2 minutes on [Heroku][3]

# Installation

    sudo gem install firefly

After you have installed the Firefly gem you should create a `config.ru` file that tells your webserver what to do. Here is a sample `config.ru`:

    require 'rubygems'
    require 'firefly'

    disable :run

    app = Firefly::Server.new do
      # The domain you use for shortening.
      set :hostname,    "localhost:9393"
      # set :hostname,    "aj.gs"

      # Used for authenticating you.
      set :api_key,     "changeme"

      # Default MySQL:
      set :database,    "mysql://root:password@localhost/firefly"

      # Use Sqlite3: gem install dm-sqlite-adapter
      # set :database,    "sqlite3://#{Dir.pwd}/firefly.sqlite3"

      # Set the number of recent urls to show in the overview.
      # Defaults to 25
      # set :recent_urls, 10

      # Set the tweet template.
      # The tag %short_url% will be replaced with the actual url.
      #
      # Default: Check this out: %short_url%
      # set :tweet,       "I loved this: %short_url% - Go check it out now!"

      # If you want to enable 'share to sharing targets'

      # A secure key to be used with 'share to sharing targets'
      # set :sharing_key,    "set-a-long-secure-key-here"

      # Currently only twitter, hyves and facebook are supported
      # set :sharing_targets, [:twitter, :hyves, :facebook]

      # Set the TLDs (in URLs) that are allowed to be shortened
      # set :sharing_domains, ["example.com", "mydomain.com"]

      # Set your session secret here.
      # If you're unsure what to use, open IRB console and run `'%x' % rand(2**255)`
      set :session_secret, "change-me"
    end

    run app

Next you can start your web server. You may try thin:

    thin start -R config.ru

Now visit `http://:hostname/` and enter your `:api_key`. Happy URL shortening!

# Enabling QR Codes

To enable QR Codes install the `barby` and `png` gems:

    gem install barby png

Firefly will detect you have these gems available and enable QR Code support automatically.

# Configuration

All configuration is done in `config.ru`. 

 * `:hostname` sets the hostname to use for shortened URLs. 
 * `:api_key` sets the API key. This key is required when posting new URLs
 * `:database` a database URI that [DataMapper][4] can understand.
 * `:recent_urls` sets the number of URLs to show in the overview. Default: 25.
 * `:tweet` set the template to use for tweets. Default: `"Check this out: %short_url%"`
 * `:sharing_key` set this to something long and secure, used for
   creating 'share to sharing targets' links.
 * `:sharing_targets` set to `[:twitter, :hyves, :facebook]` if you want to enable sharing 
   to twitter, hyves or facebook
 * `:sharing_domains` set to an array of TLDs. Only urls shared in those
   domains will be allowed. Set to an empty array (`[]`) if you want to
accept all domains.

It's possible to use all kinds of backends with DataMapper. Sqlite3 and MySQL have been tested, but others may work as well. 

# Usage

Simply visit `http://:hostname/` and enter your `:api_key`. You can now shorten URLs.

## Using the API

You may also use the API to automate URL shortening. Here's how.

Adding a URL is done by doing a simple POST request that includes the URL and your API key. 

    curl -d "url=http://ariejan.net" -d "api_key=test" http://localhost:3000/api/add

If you're on a MacOSX you could add the following function to your  `~/.profile` to automate URL shortening:

    shorten(){
      URL=$1
      SHORT_URL=`curl -s -d "url=$URL&api_key=test" http://localhost:3000/api/add`
      echo $SHORT_URL | pbcopy

      echo "-- $URL => $SHORT_URL"
      echo "Short URL copied to clipboard."
    }

After you restart Terminal.app (or at least reload the `.profile` file) you can use it like this:

    $ shorten http://ariejan.net
    -- http://ariejan.net => http://aj.gs/1
    Short URL copied to clipboard.

## Using the social features (Twitter, Facebook, etc.)

The share to sharing targets feature allows you to create custom links on your
site. When clicked, the specified URL will be shortened and the user
will be redirect to Twitter to share the new short URL.

    GET /api/share
    POST /api/share

    Parameters:
      url - Long URL to share (required)
      key - The sharing key, specified in `config.ru` (required)
      target - Target to share to. E.g. `twitter` or `facebook` (required)
      title - Title of text to use in the tweet (optional)

# Bugs, Feature Requests, etc. 

 * [Source][5]
 * [Issue tracker][6]

Feel free to fork Firefly and create patches for it. Here are some basic instructions:

 * [Fork][7] Firefly 
 * Create a topic branch - `git checkout -b my_branch`
 * Write tests and code
 * Push to your branch - `git push origin my_branch`
 * Create a GitHub Pull Request so I can merge your changes
 * That's it!

[1]: http://ariejan.net/2010/07/12/screencast-firefly-url-shortener-in-less-than-25-minutes/
[2]: http://ariejan.net/2010/06/06/setup-your-own-firefly-url-shortener-in-25-minutes/
[3]: http://heroku.com
[4]: http://datamapper.org/
[5]: http://github.com/ariejan/firefly
[6]: http://github.com/ariejan/firefly/issues
[7]: http://help.github.com/forking/
[8]: http://github.com/ariejan/firefly/issues

# Contributors

 * Ariejan de Vroom - Original author
 * Matthew Boeh - Contributor
 * Joost Saanen - Contributor

# License

    Copyright (c) 2009 Ariejan de Vroom

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

