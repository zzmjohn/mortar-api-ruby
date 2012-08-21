module Mortar
  class API

    # POST /v2/login
    def post_login(username, password)
      # reset authorization to use username/password basic auth
      @connection.connection[:headers]['Authorization'] = basic_auth_authorization_header(username, password)
      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/login")
      )
    end
  end
end
