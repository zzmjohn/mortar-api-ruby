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
    module Task
      STATUS_FAILURE          = "FAILURE"
      STATUS_SUCCESS          = "SUCCESS"

      STATUSES_COMPLETE       = Set.new([STATUS_FAILURE, 
                                        STATUS_SUCCESS])
    end
    
    # GET /vX/tasks/:task
    def get_task(task_id)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/tasks/#{task_id}")
      )
    end
    
  end
end
