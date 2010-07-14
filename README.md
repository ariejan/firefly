# FireFly

FireFly is a simple URL shortener for personal (or not so personal) use.

# Quick-Start (2 minutes) with Heroku

See the [screencast][1] or [written instructions][2] on how to setup Firefly within 2 minutes on [Heroku][3]

[1]: http://ariejan.net/2010/07/12/screencast-firefly-url-shortener-in-less-than-25-minutes/
[2]: http://ariejan.net/2010/06/06/setup-your-own-firefly-url-shortener-in-25-minutes/
[3]: http://heroku.com

# Installation

    sudo gem install firefly

After you have installed the Firefly gem you should create a `config.ru` file that tells your webserver what to do. Here is a sample `config.ru`:

    require 'rubygems'
    require 'firefly'
    
    disable :run
    
    app = Firefly::Server.new do
      # The domain you use for shortening.
      set :hostname,    "localhost:3000"
      # set :hostname,    "aj.gs"
      
      # Used for authenticating you.
      set :api_key,     "test"
      
      # Use Sqlite3 by default
      set :database,    "sqlite3://#{Dir.pwd}/firefly.sqlite3"
      
      # You can use MySQL as well. 
      # Make sure to install the do_mysql gem:
      #    sudo gem install do_mysql
      # set :database,    "mysql://root@localhost/firefly"
      
      # Set the number of recent urls to show in the overview.
      # Defaults to 25
      # set :recent_urls, 10
      
      # Set the tweet template.
      # The tag %short_url% will be replaced with the actual url.
      #
      # Default: Check this out: %short_url%
      # set :tweet,       "I loved this: %short_url% - Go check it out now!"
    end
    
    run app

Next you can start your web server. You may try thin:

    thin start -R config.ru

Now visit `http://:hostname/` and enter your `:api_key`. Happy URL shortening!

# Configuration

All configuration is done in `config.ru`. 

 * `:hostname` sets the hostname to use for shortened URLs. 
 * `:api_key` sets the API key. This key is required when posting new URLs
 * `:database` a database URI that [DataMapper][1] can understand.
 * `:recent_urls` sets the number of URLs to show in the overview. Default: 25.
 * `:tweet` set the template to use for tweets. Default: `"Check this out: %short_url%"`

It's possible to use all kinds of backends with DataMapper. Sqlite3 and MySQL have been tested, but others may work as well. 

[1]: http://datamapper.org/

# Usage

Simply visit `http://:hostname/` and enter your `:api_key`. You can now shorten URLs.

## Advanced usage

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
    
# Bugs, Feature Requests, etc. 

 * [Source][2]
 * [Issue tracker][3]

[2]: http://github.com/ariejan/firefly
[3]: http://github.com/ariejan/firefly/issues

Feel free to fork Firefly and create patches for it. Here are some basic instructions:

 * [Fork][4] Firefly 
 * Create a topic branch - `git checkout -b my_branch`
 * Push to your branch - `git push origin my_branch`
 * Create an [Issue][5] with a link to your branch
 * That's it!
 
[4]: http://help.github.com/forking/
[5]: http://github.com/ariejan/firefly/issues

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

