require 'smartling_api/errors/client'

module SmartlingApi
  module Errors
    # Error to be thrown when 422 occurs when accessing Smartling API
    class UnprocessableEntity < Client; end
  end
end
