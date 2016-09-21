require 'smartling_api/errors/client'

module SmartlingApi
  module Errors
    # Error to be thrown when 404 occurs when accessing Smartling API
    class NotFound < Client; end
  end
end
