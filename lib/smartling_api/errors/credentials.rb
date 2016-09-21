module SmartlingApi
  module Errors
    # Error to be thrown when smartling id and secret has not been set
    class Credentials < StandardError
      def initialize(msg="Please enter smartling credentials")
        super
      end
    end
  end
end
