#
# Copyright 2012 Mortar Data Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
