# Smartling Api

![Build Status](https://travis-ci.org/redbubble/smartling_api.svg?branch=master)
[![Code Climate](https://codeclimate.com/github/redbubble/smartling_api/badges/gpa.svg)](https://codeclimate.com/github/redbubble/smartling_api)
[![Gem Version](https://badge.fury.io/rb/smartling_api.svg)](https://badge.fury.io/rb/smartling_api)
[![Docs](https://inch-ci.org/github/redbubble/smartling_api.svg?branch=master)

## Overview

Ruby wrapper for accessing the Smartling Translation API V2.

The Smartling Translation API lets developers to internationalize their website or app by automating the translation and integration of their site content. Developers can upload resource files and download the translated files in a language of their choosing. There are options to allow for professional translation, community translation and machine translation.

[Smartling API V2](http://docs.smartling.com/pages/API/v2/)

## Requirements

- ruby 2.0+

## Installation

Add this line to your application's Gemfile:

  	gem 'smartling_api', '0.2.0'

## Usage

### Configure

You will need to configure smartling user id and secret. In Rails you would put it in an initializer file.

	SmartlingApi.configure do |config|
  	  config.id = <id>
  	  config.secret = <secret>
  	  config.project_id = <project_id> # Optional
	end

You can obtain an id, secret via [Create Authentication Tokens](http://docs.smartling.com/pages/API/v2/Authentication/)

The `project_id` is optional.  If you are only using a single `project_id` per application then you may add your `project_id` here.  If not you will have to pass the `project_id` when you create your api call. Examples below.

## Authentication Api


### Retrieve Access Token

-  [Authenticate API](http://docs.smartling.com/pages/API/v2/Authentication/Authenticate). Retrieve OAuth2 access token to be used with each api call.


		> SmartlingApi::Authentication.new.access_token 
		=> "Token"

The Authentication API will throw `SmartlingApi::Errors::Credentials` if the Smartling id and/or secret has not been set.

## Project Api

Create a Project Api via,

@param `token`: Optional ( Will default to using authentication api to retrieve access token )
	
@param `project_id`: Optional ( Will default to using configured project_id )

	> SmartlingApi::Project.new
	or
	> SmartlingApi::Project.new(token: 'token', project_id: 'project_id')
	

- [List Locales API](http://docs.smartling.com/pages/API/v2/Projects/List-Projects/). Retrieve a list of all locales available.

		> SmartlingApi::Project.new.list_locales
		=> [{ "localeId" => "de-DE", "description" => "German (Germany)" }, ...]
		
		
## File Api
Create a Project Api via,

@param `token`: Optional ( Will default to using authentication api to retrieve access token )
	
@param `project_id`: Optional ( Will default to using configured project_id )

	> SmartlingApi::File.new
	or
	> SmartlingApi::File.new(token: 'token', project_id: 'project_id')
	

- [Delete File API](http://docs.smartling.com/pages/API/v2/FileAPI/Delete/). Delete a file within Smartling.

	@param `file_uri`: File path within Smartling to delete

		> SmartlingApi::File.new.delete(file_uri: '/translations/website') 
		=> { "code" => "SUCCESS" }
		


- [Download Locale File API](http://docs.smartling.com/pages/API/v2/FileAPI/Download-File/Single-Locale/).  Returns the content of a file for the given locale and path.

	@param `file_uri`: File path within Smartling to download
	
	@param `locale_id`: Locale Id of file to download

		> SmartlingApi::File.new.download_locale(locale_id: 'fr-Fr', file_uri: '/translation/website') 
		=> "translations"
		

- [List File API](http://docs.smartling.com/pages/API/v2/FileAPI/List/).  Retrieve list of files for a given project.

	@param `**options`: Additional options for the given request. NOTE: If using a hash as parameters ensure all keys are symbols and then use `**options`.  See Smartling API Doc for options.

		> SmartlingApi::File.new.list_files(uriMask: '.json') 
		=> [{"fileUri" => "[/translate/file.json]", ...}]
		

- [Upload File API](http://docs.smartling.com/pages/API/v2/FileAPI/Upload-File/).  Upload a file to the given path.

	@param `file_path`: Location of file to upload
	
	@param `file_uri`: File path within smartling
	
	@param `file_type`: Type of file to upload. See Smartling API DOC for types.
	
	@param `**options`: Additional options for the given request. NOTE: If using a hash as parameters ensure all keys are symbols and then use `**options`.  See Smartling API Doc for options.

		SmartlingApi::File.new.upload(file_path: 'website.pot', file_uri: '/translation/website', file_type: 'gettext') 
		=> { "code" => "SUCCESS" }
		

## Errors

SmartlingApi will handle errors according to the response received from Smartling.  The errors that might be thrown on a request are,

```
  404 => SmartlingApi::Errors::NotFound,
  422 => SmartlingApi::Errors::UnprocessableEntity,
  500 => SmartlingApi::Errors::InternalServer
```

The errors all inherit, and will default to `SmartlingApi::Errors::Client` if any other response other than 2xx or 3xx is received.

## Todo

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

## Credits

[![](/redbubble.png)][redbubble]

smartling api is maintained and funded by [Redbubble][redbubble].

  [redbubble]: https://www.redbubble.com

## License

Licensed under [MIT](./LICENCE.txt)
