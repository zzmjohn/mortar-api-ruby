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
    module Fixtures
      STATUS_GATEWAY_STARTING = 'GATEWAY_STARTING'
      STATUS_PENDING = 'PENDING'
      STATUS_CREATING = 'CREATING'
      STATUS_SAVING = 'SAVING'
      STATUS_CREATED = 'CREATED'
      STATUS_FAILED = 'FAILED'
      
      STATUSES_COMPLETE = Set.new([STATUS_CREATED, 
                                   STATUS_FAILED])
    end
    
    # GET /vX/fixtures/:fixture
    def get_fixture(fixture_id)
      request(
        :expects  => 200,
        :idempotent => true,
        :method   => :get,
        :path     => versioned_path("/fixtures/#{fixture_id}")
      )
    end

    # POST /vX/fixtures 
    def post_fixture_limit(project_name, fixture_name, input_url, num_rows)
      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/fixtures"),
        :body     => json_encode({"fixture_name" => fixture_name,
                                  "project_name" => project_name,
                                  "s3_url"       => input_url,
                                  "num_rows"     => num_rows})
      )
    end
  end
end
