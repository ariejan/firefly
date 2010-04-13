# FireFly API

FireFly exposes its data via an Application Programming Interface (API), so developers can interact in a programmatic way with the FireFly website. This document is the official reference for that functionality. The current API version is 1.0

## Request / Response

FireFly responds in JSON.

A normal response may look like this:

    {
      "status_code": 200,
      "data": {
        "url": "http://example.com/cmeH01", 
        "hash": "cmeH01",
        "long_url": "http://ariejan.net/", 
        "new_hash": 0
      }
    }

**Status codes**

FireFly sends back a `status_code`:

 * 200 - OK
 * 401 - Permission denied - wrong API key
 * 404 - Hash or short URL not found (only for `expand` and `clicks`)
 * 500 - Something bad happened.

## /v1/shorten

Shorten a long url to a short one.

    GET /v1/shorten
    
**Parameters**

 * `api_key` - Your API key, used for authentication
 * `long_url` - The long URL. E.g. 'http://ariejan.net/'

**Output**

 * `new_hash` - Is 1 if it's the first time the `long_url` is shortened, 0 otherwise.
 * `url` - The short URL
 * `hash` - The FireFly hash, this is a unique value
 * `long_url` - Echos back the `long_url` that was shortened

## /v1/expand

Expand a short URL or hash to the long url.

    GET /v1/expand
    
**Parameters**

 * `short_url` - A valid short URL
 * `hash` - A valid hash
 * `api_key` - Your API key
 
_Note that either `short_url` or `hash` must be specified_

**Output**

 * `short_url` - The short URL
 * `hash` - The FireFly hash
 * `long_url` - The original long URL

## /v1/clicks

Request the number of clicks of a specific short URL or hash.

    GET /v1/clicks
    
**Parameters**

 * `api_key` - Your API key
 * `short_url` - A short URL
 * `hash` - A hash

_Note that either `short_url` or `hash` must be specified_

**Output**

 * `short_url` - The short URL
 * `hash` - The FireFly hash
 * `clicks` - The total number of clicks on this link