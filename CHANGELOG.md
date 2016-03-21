# Changelog

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

 * Full rewrite of the entire application using Hanami. Clean code, fully tested.

## [1.5.3] - 2011-05-05

 * Force all instances of Firefly to use the same session_secret so logins work properly with multi-instance setups (issue #30) [ariejan]

## [1.5.2] - 2011-05-02

 * Fixed issue with sharing a link without a title (issue #26) [ariejan]

## [1.5.1] - 2011-04-22

 * Truncate long URLs in the backend to preserve layout (issue #25) [ariejan]
 * Accept URL encoded titles when sharing to Twitter and Hyves (issue #28) [ariejan]

## [1.5.0] - 2011-04-21

 * Firefly is now compatible with ruby 1.8.7, 1.9.2 and ree-1.8 [ariejan]
 * Added support for sharing to hyves [stalkert]
 * Added support for sharing to facebook [stalkert]
 * Removed exports because they add to much overhead [ariejan]

## [1.4.1] - 2011-02-11

 * Strip leading and trailing whitespace from titles when sharing [ariejan]
 * Make sure shared titles don't exceed a total of 140 characters for twitter [ariejan]

## [1.4.0] - 2011-02-11

 * Added support for 'share to twitter' links [ariejan]

## [1.3.1] - 2011-02-20

 * Fixed issue with escaped characters in URL (ticket #21) [ariejan]

## [1.3.0] - 2011-02-01

 * Improved GUI [ariejan]
 * Improved error handling / reporting [ariejan]
 * Added a CodeFactory to generate unique short codes (and prevent collisions with custom short codes) [ariejan]
 * Use dm-mysql-adapater as default, dm-sqlite-adapter is optional [ariejan]

## [1.2.2] - 2011-01-26

 * Added GUI support for custom short codes. [ariejan]

## [1.2.0] - 2011-01-26

 * Support for specifying one's own preferred short codes via the API. Also, invalid URL creations return a 422 code, not 200. [ariejan]
 * Make Barby optional to save some gems for those of us who don't need QR code generation. [mboeh]

## [1.1.0] - 2010-10-02

 * Generate a QR Code image when accessing http://:host/:code.png [ariejan]

## [1.0.0] - 2010-09-19

 * Added better support for URLs with spaces and other special characters. Closes #19 [ariejan]

## [0.4.5] - 2010-08-10

 * Added sorting of shortened URLs. Closes #12. [ariejan]
 * Added CSV, XML and YAML export of all shortened URLs. Closes #11. [ariejan]
 * Updated bookmarklet JavaScript to escape URL-unsafe charachters in the API key. Fixes #17 [ariejan]

## [0.4.4] - 2010-06-20

 * Updated gem dependencies for DataMapper 1.0.0 [ariejan]

## [0.4.3] - 2010-06-06 

 * Handle invalid API keys correctly. [ariejan]

## [0.4.2] - 2010-06-06 

 * Added a fix for MySQL users to update the `code` column to use the correct collation. Fixes #9 [ariejan]

## [0.4.1] - 2010-04-30

 * Normalize URLs before shortening them. This prevents false duplicates. [ariejan]
 * Validate URLs to be valid HTTP or HTTPS, don't accept others. [ariejan]
 * Don't ask for the API key after shortening a URL with the bookmarklet. [ariejan]
 * Show the highlighted URL separately. Closes #7. [ariejan]

## [0.4.0.1] - 2010-04-14

 * Correct file permission of `public/images/twitter.png`. [ariejan]

## [0.4.0] - 2010-04-14

 * Added button to quickly tweet a URL. Closes #3 [ariejan]
 * Disable autocomplete and spellcheck for the big url input field. Closes #6 [ariejan]
 * After shortening an URL highlight the url that was added in the overview. [ariejan]
 * Made it easy to copy a short url from the overview. Closes #4 [ariejan]
 * Added links to source and issues in footer. [ariejan]
 * Include domain name in page title. [ariejan]

## [0.3.1] - 2010-04-13

 * Fixed issue with setting `created_at` timestamp. [ariejan]

## [0.3.0] - 2010-04-13

 * Added recent urls to dashboard [ariejan]
 * Added bookmarklet [ariejan]
 * Split up Firefly codebase for better testing and maintainability [ariejan]
 * Added Ruby 1.9.x compatibility. [ariejan]

## [0.2.0] - 2010-03-29 
  
 * Added some GUI sugar at '/'. [ariejan]
 * Added /api/info/:code for basic stats on the specified URL. [ariejan]
 * Keep count of the number of visits to a given URL. [ariejan]
 * Fill in `created_at` for Firefly::Url. [ariejan]
 * Changed Firefly::Url String properties to a length of 255 instead of the default of 50. [ariejan]

## 0.0.1 - 2010-03-28

 * First official release

[Unreleased]: https://github.com/ariejan/firefly/compare/v1.5.3...HEAD
[1.5.3]: https://github.com/ariejan/firefly/compare/v1.5.2...v1.5.3
[1.5.2]: https://github.com/ariejan/firefly/compare/v1.5.1...v1.5.2
[1.5.1]: https://github.com/ariejan/firefly/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/ariejan/firefly/compare/v1.4.1...v1.5.0
[1.4.1]: https://github.com/ariejan/firefly/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/ariejan/firefly/compare/v1.3.1...v1.4.0
[1.3.1]: https://github.com/ariejan/firefly/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/ariejan/firefly/compare/v1.2.2...v1.3.0
[1.2.2]: https://github.com/ariejan/firefly/compare/v1.2.0...v1.2.2
[1.2.0]: https://github.com/ariejan/firefly/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/ariejan/firefly/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/ariejan/firefly/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/ariejan/firefly/compare/v0.4.5...v1.0.0
[0.4.5]: https://github.com/ariejan/firefly/compare/v0.4.4...v0.4.5
[0.4.4]: https://github.com/ariejan/firefly/compare/v0.4.3...v0.4.4
[0.4.3]: https://github.com/ariejan/firefly/compare/v0.4.2...v0.4.3
[0.4.2]: https://github.com/ariejan/firefly/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/ariejan/firefly/compare/v0.4.0.1...v0.4.1
[0.4.0.1]: https://github.com/ariejan/firefly/compare/v0.4.0...v0.4.0.1
[0.4.0]: https://github.com/ariejan/firefly/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/ariejan/firefly/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/ariejan/firefly/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/ariejan/firefly/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/ariejan/firefly/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/ariejan/firefly/compare/v0.0.1...v0.0.2

