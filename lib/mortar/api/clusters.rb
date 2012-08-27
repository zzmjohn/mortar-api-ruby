module Mortar
  class API
    
    # GET /vX/clusters
    def get_clusters()
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/clusters")
      )
    end    
  end
end
