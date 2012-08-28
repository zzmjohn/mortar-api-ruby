require 'set'

module Mortar
  class API
    module Validate

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
    
    # GET /vX/validates/:validate
    def get_validate(validate_id, options = {})
      exclude_result = options[:exclude_result] || false
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/validates/#{validate_id}"),
        :query    => {:exclude_result => exclude_result}
      )
    end
    
    # POST /vX/validates
    def post_validate(project_name, pigscript, git_ref, options = {})
      parameters = options[:parameters] || {}
      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/validates"),
        :body     => json_encode({"project_name" => project_name,
                                  "pigscript_name" => pigscript,
                                  "git_ref" => git_ref,
                                  "parameters" => parameters
                                  })
      )
    end
  end
end
