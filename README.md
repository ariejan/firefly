# Firefly 2.0 [![Build Status](https://secure.travis-ci.org/ariejan/firefly.png?branch=master)](http://travis-ci.org/ariejan/firefly)

Firefly 2.0 is still very much under active development, meaning that the current `master` is not usable for production in any way.

## Feature roadmap

Firefly 2.0 is a complete re-invention of the original Firefly. Although all Firefly 1.0 features will be available in 2.0, the API will _not be backward compatible_.

The first step is to start work on the JSON API. Next up is the front-end, which will probably be written in one of the popular Javascript frameworks like Backbone.js, Spine.js or Ember.js.

There is no release date set for Firefly 2.0.

## Requesting features

You're free to request features. Please use [the issue tracker](https://github.com/ariejan/firefly/issues) for this. Please look through the other feature requests first, to avoid duplicates.

## Running specs

Firefly 2.0 only has a JSON API at this time. You can test it like this:

    git clone 
    cd firefly
    cp config/database.yml.{mysql|postgresql} config/database.yml
    bundle install
    rake db:create
    rake db:migrate
    rake spec
    
If you find any bugs, please post the to [the issue tracker](https://github.com/ariejan/firefly/issues). Please search through the existing issues first to see if it's already reported. This avoids duplicate tickets and work.
    
## Contributing

Yes, you can contribute! I'm mostly looking for someone who could take are of the front-end at this moment. Contributions to further extend or improve the API are also welcome.

 * Fork the project
 * Create a feature branc
 * Write tests and code
 * Create a pull request
 
## License

Copyright (c) 2009-2012 Ariejan de Vroom

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