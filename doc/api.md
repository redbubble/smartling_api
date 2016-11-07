API Documentation
=================

Authentication Api
------------------

**Retrieve Access Token**

-  [Authenticate API](http://docs.smartling.com/pages/API/v2/Authentication/Authenticate). Retrieve OAuth2 access token to be used with each api call.


		> SmartlingApi::Authentication.new.access_token 
		=> "Token"

The Authentication API will throw `SmartlingApi::Errors::Credentials` if the Smartling id and/or secret has not been set.

Project Api
-----------

Create a Project Api via,

@param `token`: Optional ( Will default to using authentication api to retrieve access token )
	
@param `project_id`: Optional ( Will default to using configured project_id )

	> SmartlingApi::Project.new
	or
	> SmartlingApi::Project.new(token: 'token', project_id: 'project_id')
	

- [List Locales API](http://docs.smartling.com/pages/API/v2/Projects/List-Projects/). Retrieve a list of all locales available.

		> SmartlingApi::Project.new.list_locales
		=> [{ "localeId" => "de-DE", "description" => "German (Germany)" }, ...]
		
		
File Api
--------

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
		
