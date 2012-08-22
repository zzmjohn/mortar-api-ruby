require "base64"

module Mortar
  class API
    module BasicAuth

      extend self

      def basic_auth_authorization_header(user, password)
        encoded = Base64.encode64("#{user}:#{password}").gsub("\n", '')
        "Basic #{encoded}"
      end
      
    end
  end
end