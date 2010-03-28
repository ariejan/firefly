# FireFly

FireFly is a simple URL shortner for personal use.

# Installation

    git clone git://github.com/ariejan/firefly.git
    bundle install
    bundle lock
    thin start -R config.ru
    
# Usage

    curl -d "url=http://ariejan.net&api_key=test" http://localhost:3000/api/add
    
or if you're on MacOSX, add the following to your `~/.profile`

    shorten(){
      URL=$1
      SHORT_URL=`curl -s -d "url=$URL&api_key=test" http://localhost:3000/api/add`
      echo $SHORT_URL | pbcopy
      
      echo "-- $URL => $SHORT_URL"
      echo "Short URL copied to clipboard."
    }
    
And use it like this: (you may need to restart Terminal.app)

    $ shorten http://ariejan.net
    -- http://ariejan.net => http://aj.gs/1
    Short URL copied to clipboard.