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

    # PUT /v2/user/:user
    def update_user(user_id, options={})
      body = json_encode(options)
      request(
        :expects  => 200,
        :method   => :put,
        :path     => versioned_path("/user/#{user_id}"),
        :body     => body
      )
    end

  end
end
