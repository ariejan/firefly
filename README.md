# FireFly

FireFly is a simple URL shortner for personal use.

# Installation

    git clone git://github.com/ariejan/firefly.git
    bundle install
    bundle lock
    thin start -R config.ru
    
# Usage

    curl -d "url=http://ariejan.net&api_key=test" http://localhost:3000/api/add
    