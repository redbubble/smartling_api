Smartling Api
=============

![Build Status](https://travis-ci.org/redbubble/smartling_api.svg?branch=master)
[![Code Climate](https://codeclimate.com/github/redbubble/smartling_api/badges/gpa.svg)](https://codeclimate.com/github/redbubble/smartling_api)
[![Gem Version](https://badge.fury.io/rb/smartling_api.svg)](https://badge.fury.io/rb/smartling_api)
![Docs](https://inch-ci.org/github/redbubble/smartling_api.svg?branch=master)

Overview
--------

Ruby wrapper for accessing the Smartling Translation API V2.

The Smartling Translation API lets developers to internationalize their website or app by automating the translation and integration of their site content. Developers can upload resource files and download the translated files in a language of their choosing. There are options to allow for professional translation, community translation and machine translation.

[Smartling API V2](http://docs.smartling.com/pages/API/v2/)


Installation
------------

###Requirements

- ruby 2.0+

###Setup

Add this line to your application's Gemfile:

  	gem 'smartling_api', '0.2.0'
  	
###Run Tests

  	bundle exec rspec
  	

Usage
-----

###Config

You will need to configure smartling user id and secret. In Rails you would put it in an initializer file. eg. `<project_home>/config/smartling_api.rb`

	SmartlingApi.configure do |config|
  	  config.id = <id>
  	  config.secret = <secret>
  	  config.project_id = <project_id> # Optional
	end

You can obtain an id, secret via [Create Authentication Tokens](http://docs.smartling.com/pages/API/v2/Authentication/)

The `project_id` is optional.  If you are only using a single `project_id` per application then you may add your `project_id` here.  If not you will have to pass the `project_id` when you create your api call. Examples below.

###Api Documentation

You can find all api documentation on: [Api Documentation](./doc/api.md)

###Errors

SmartlingApi will handle errors according to the response received from Smartling.  The errors that might be thrown on a request are,

```
  404 => SmartlingApi::Errors::NotFound,
  422 => SmartlingApi::Errors::UnprocessableEntity,
  500 => SmartlingApi::Errors::InternalServer
```

The errors all inherit, and will default to `SmartlingApi::Errors::Client` if any other response other than 2xx or 3xx is received.

Todo
----

The following apis still need to be implemented:

-  Retrieve Authentication Refresh Token
-  Accounts Api: to retrieve projects for an account
-  File Api: List file types
-  File Api:  Status: All Locales
-  File Api:  Status: Single Locale
-  File Api: Rename
-  File Api:  Last Modified: Single Locale
-  File Api:  Last Modified: All Locales
-  File Api:  Import Translations
-  File Api: Get Translations
-  File Api:  Download Translated Files: Original File
-  File Api:  Download Translated Files: Multiple Locales as ZIP
-  File Api:  Download Translated Files: All Locales as ZIP
-  File Api:  Download Translated Files: All Locales in one File - CSV

Credits
-------

[![](/doc/redbubble.png)][redbubble]

smartling api is maintained and funded by [Redbubble][redbubble].

  [redbubble]: https://www.redbubble.com

License
-------

Licensed under [MIT](./LICENCE.txt)
