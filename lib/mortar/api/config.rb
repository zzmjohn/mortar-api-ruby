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
# Portions of this code from heroku (https://github.com/heroku/heroku/) Copyright Heroku 2008 - 2013,
# used under an MIT license (https://github.com/heroku/heroku/blob/master/LICENSE).
#

module Mortar
  class API
    
    # PUT /vX/config/:project_name
    def put_config_vars(project_name, config_vars)
      request(
        :expects  => 200,
        :method   => :put,
        :path     => versioned_path("/config/#{escape(project_name)}"),
        :body     => json_encode(config_vars)
      )
    end

    # GET /vX/config/:project_name
    def get_config_vars(project_name)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/config/#{escape(project_name)}")
      )
    end

    # DELETE /vX/config/:project_name
    def delete_config_var(project_name, config_var)
      body = {'key' => config_var}
      request(
        :expects => 200,
        :method  => :delete,
        :path    => versioned_path("/config/#{escape(project_name)}"),
        :body    => json_encode(body)
      )
    end
  end
end
