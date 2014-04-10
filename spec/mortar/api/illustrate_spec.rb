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

require "base64"
require "spec_helper"
require "mortar/api"


describe Mortar::API do
  
  before(:each) do
    @api = Mortar::API.new
  end
  
  after(:each) do
    Excon.stubs.clear
  end
  
  context "illustrate" do
    it "posts an illustrate" do
      illustrate_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      project_name = "my_project"
      pigscript_name = "my_pigscript"
      project_script_path = "pigscripts/my_pigscript"
      pigscript_alias = "my_alias"
      skip_pruning = false
      git_ref = "e20395b8b06fbf52e86665b0660209673f311d1a"
      parameters = {"key" => "value"}
      body = Mortar::API::OkJson.encode({"project_name" => project_name,
                                         "pigscript_name" => pigscript_name,
                                         "alias" => pigscript_alias,
                                         "skip_pruning" => skip_pruning,
                                         "git_ref" => git_ref,
                                         "parameters" => parameters,
                                         "project_script_path" => project_script_path,
                                         })
      Excon.stub({:method => :post, :path => "/v2/illustrates", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'illustrate_id' => illustrate_id}), :status => 200}
      end
      response = @api.post_illustrate(project_name, pigscript_name, pigscript_alias, skip_pruning, git_ref, :parameters => parameters, :project_script_path => project_script_path)
      response.body['illustrate_id'].should == illustrate_id
    end
    
    it "gets an illustrate" do
      illustrate_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      Excon.stub({:method => :get, :path => "/v2/illustrates/7b93e4d3ab034188a0c2be418d3d24ed"}) do |params|
        {:body => Mortar::API::OkJson.encode({'illustrate_id' => illustrate_id, 'status' => Mortar::API::Illustrate::STATUS_PROGRESS}), :status => 200}
      end
      response = @api.get_illustrate(illustrate_id)
      response.body['illustrate_id'].should == illustrate_id
      response.body['status'].should == Mortar::API::Illustrate::STATUS_PROGRESS
    end
  end
end