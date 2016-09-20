module SmartlingApi
  module Errors
    class Credentials < StandardError
      def initialize(msg="Please enter smartling credentials")
        super
      end
    end
  end
end
