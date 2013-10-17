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
    def post_describe(project_name, pigscript, pigscript_alias, git_ref, pig_version, options = {})
      parameters = options[:parameters] || {}
      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/describes"),
        :body     => json_encode({"project_name" => project_name,
                                  "pigscript_name" => pigscript,
                                  "alias" => pigscript_alias,
                                  "git_ref" => git_ref,
                                  "parameters" => parameters,
                                  "pig_version" => pig_version
                                  })
      )
    end
  end
end
