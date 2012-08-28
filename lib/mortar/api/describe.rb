require 'set'

module Mortar
  class API
    module Describe

      STATUS_QUEUED           = "QUEUED"
      STATUS_GATEWAY_STARTING = "GATEWAY_STARTING"
      STATUS_PROGRESS         = "PROGRESS"

      STATUS_FAILURE          = "FAILURE"
      STATUS_SUCCESS          = "SUCCESS"
      STATUS_KILLED           = "KILLED"

      STATUSES_IN_PROGRESS    = Set.new([STATUS_QUEUED, 
                                         STATUS_GATEWAY_STARTING,
                                         STATUS_PROGRESS])

      STATUSES_COMPLETE       = Set.new([STATUS_FAILURE, 
                                        STATUS_SUCCESS,
                                        STATUS_KILLED])
    end
    
    # GET /vX/describes/:describe
    def get_describe(describe_id, options = {})
      exclude_result = options[:exclude_result] || false
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/describes/#{describe_id}"),
        :query    => {:exclude_result => exclude_result}
      )
    end
    
    # POST /vX/describes
    def post_describe(project_name, pigscript, pigscript_alias, git_ref, options = {})
      parameters = options[:parameters] || {}
      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/describes"),
        :body     => json_encode({"project_name" => project_name,
                                  "pigscript_name" => pigscript,
                                  "alias" => pigscript_alias,
                                  "git_ref" => git_ref,
                                  "parameters" => parameters
                                  })
      )
    end
  end
end
