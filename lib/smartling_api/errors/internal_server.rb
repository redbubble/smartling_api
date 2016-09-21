require 'smartling_api/errors/client'

module SmartlingApi
  module Errors
    # Error to be thrown when 500 occurs when accessing Smartling API
    class InternalServer < Client; end
  end
end
