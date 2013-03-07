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
    module Jobs

      STATUS_STARTING          = "starting"
      STATUS_GATEWAY_STARTING  = "GATEWAY_STARTING" #Comes from task.
      STATUS_VALIDATING_SCRIPT = "validating_script"
      STATUS_SCRIPT_ERROR      = "script_error"
      STATUS_PLAN_ERROR        = "plan_error"
      STATUS_STARTING_CLUSTER  = "starting_cluster"
      STATUS_RUNNING           = "running"
      STATUS_SUCCESS           = "success"
      STATUS_EXECUTION_ERROR   = "execution_error"
      STATUS_SERVICE_ERROR     = "service_error"
      STATUS_STOPPING          = "stopping"
      STATUS_STOPPED           = "stopped"

      STATUSES_IN_PROGRESS    = Set.new([STATUS_STARTING,
                                         STATUS_GATEWAY_STARTING,
                                         STATUS_VALIDATING_SCRIPT, 
                                         STATUS_STARTING_CLUSTER, 
                                         STATUS_RUNNING, 
                                         STATUS_STOPPING])

      STATUSES_COMPLETE       = Set.new([STATUS_SCRIPT_ERROR, 
                                        STATUS_PLAN_ERROR,
                                        STATUS_SUCCESS,
                                        STATUS_EXECUTION_ERROR,
                                        STATUS_SERVICE_ERROR,
                                        STATUS_STOPPED])
    end
    
    
    # POST /vX/jobs
    def post_job_existing_cluster(project_name, script_name, git_ref, cluster_id, options={})
      parameters = options[:parameters] || {}
      notify_on_job_finish = options[:notify_on_job_finish].nil? ? true : options[:notify_on_job_finish]
      is_control_script = options[:is_control_script] || false
      
      body = {"project_name" => project_name,
        "git_ref" => git_ref,
        "cluster_id" => cluster_id,
        "parameters" => parameters,
        "notify_on_job_finish" => notify_on_job_finish
      }
      
      if is_control_script
        body["controlscript_name"] = script_name
      else
        body["pigscript_name"] = script_name
      end

      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/jobs"),
        :body     => json_encode(body))
    end

    
    # POST /vX/jobs
    def post_job_new_cluster(project_name, script_name, git_ref, cluster_size, options={})
      keep_alive = options[:keepalive].nil? ? true : options[:keepalive]
      notify_on_job_finish = options[:notify_on_job_finish].nil? ? true : options[:notify_on_job_finish]
      parameters = options[:parameters] || {}
      is_control_script = options[:is_control_script] || false
      
      body = { "project_name" => project_name,
        "git_ref" => git_ref,
        "cluster_size" => cluster_size,
        "keep_alive" => keep_alive,
        "parameters" => parameters,
        "notify_on_job_finish" => notify_on_job_finish
      }
      if is_control_script
        body["controlscript_name"] = script_name
      else
        body["pigscript_name"] = script_name
      end

      request(
        :expects  => 200,
        :method   => :post,
        :path     => versioned_path("/jobs"),
        :body     => json_encode(body))
    end

    # GET /vX/jobs
    def get_jobs(skip, limit)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/jobs"),
        :query    => { :skip => skip, :limit => limit }
      )
    end
    
    # GET /vX/jobs/:job_id
    def get_job(job_id)
      request(
        :expects  => 200,
        :method   => :get,
        :path     => versioned_path("/jobs/#{job_id}")
      )
    end

    # DELETE /v2/jobs/:job_id
    def stop_job(job_id)
      request(
        :expects => 200,
        :method  => :delete,
        :path    => versioned_path("/jobs/#{job_id}")
      )
    end
  end
end
