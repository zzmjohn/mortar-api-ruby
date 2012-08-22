module Mortar
  class API

    # GET /v2/user
    def get_user
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/user")
      )
    end

  end
end
