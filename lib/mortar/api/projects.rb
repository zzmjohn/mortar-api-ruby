require 'set'

module Mortar
  class API
    module Projects
      STATUS_PENDING    = "PENDING"
      STATUS_CREATING   = "CREATING"
      STATUS_ACTIVE     = "ACTIVE"
      STATUS_FAILED     = "FAILED"
      
      STATUSES_COMPLETE = Set.new([STATUS_ACTIVE, 
                                   STATUS_FAILED])
    end
    
    # GET /vX/projects
    def get_projects()
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/projects")
      )
    end
    
    # GET /vX/projects/:project
    def get_project(project_id)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/projects/#{project_id}")
      )
    end
    
    # POST /vX/projects
    def post_project(project_name)
      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/projects"),
        :body     => json_encode({"project_name" => project_name})
      )
    end 
  end
end
