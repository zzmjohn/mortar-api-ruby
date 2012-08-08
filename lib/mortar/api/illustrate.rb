require 'set'

module Mortar
  class API
    module Illustrate

      STATUS_QUEUED           = "QUEUED"
      STATUS_PROGRESS         = "PROGRESS"
      STATUS_BUILDING_PLAN    = "BUILDING_PLAN"
      STATUS_READING_DATA     = "READING_DATA"
      STATUS_PRUNING_DATA     = "PRUNING_DATA"

      STATUS_FAILURE          = "FAILURE"
      STATUS_SUCCESS          = "SUCCESS"
      STATUS_KILLED           = "KILLED"

      STATUSES_IN_PROGRESS    = Set.new([STATUS_QUEUED, 
                                         STATUS_PROGRESS, 
                                         STATUS_BUILDING_PLAN, 
                                         STATUS_READING_DATA, 
                                         STATUS_PRUNING_DATA])

      STATUSES_COMPLETE       = Set.new([STATUS_FAILURE, 
                                        STATUS_SUCCESS,
                                        STATUS_KILLED])
    end
    
    # GET /vX/illustrates/:illustrate
    def get_illustrate(illustrate_id, options = {})
      exclude_result = options[:exclude_result] || false
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/illustrates/#{illustrate_id}"),
        :query    => {:exclude_result => exclude_result}
      )
    end
    
    # POST /vX/illustrates
    def post_illustrate(project_name, pigscript, pigscript_alias, git_ref)
      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/illustrates"),
        :body     => json_encode({"project_name" => project_name,
                                  "pigscript_name" => pigscript,
                                  "alias" => pigscript_alias,
                                  "git_ref" => git_ref})
      )
    end    
  end
end
