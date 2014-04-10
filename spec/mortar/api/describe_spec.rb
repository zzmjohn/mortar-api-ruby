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
  
  context "describe" do
    it "posts a describe" do
      describe_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      project_name = "my_project"
      pigscript_name = "my_pigscript"
      project_script_path = "pigscripts/my_pigscript/"
      pigscript_alias = "my_alias"
      git_ref = "e20395b8b06fbf52e86665b0660209673f311d1a"
      params = {"key" => "value"}
      body = Mortar::API::OkJson.encode({"project_name" => project_name,
                                         "pigscript_name" => pigscript_name,
                                         "alias" => pigscript_alias,
                                         "git_ref" => git_ref,
                                         "parameters" => params,
                                         "project_script_path" => project_script_path,
                                         })
      Excon.stub({:method => :post, :path => "/v2/describes", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'describe_id' => describe_id}), :status => 200}
      end
      response = @api.post_describe(project_name, pigscript_name, pigscript_alias, git_ref, :parameters => params, :project_script_path => project_script_path)
      response.body['describe_id'].should == describe_id
    end
    
    it "gets a describe" do
      describe_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      Excon.stub({:method => :get, :path => "/v2/describes/7b93e4d3ab034188a0c2be418d3d24ed"}) do |params|
        {:body => Mortar::API::OkJson.encode({'describe_id' => describe_id, 'status' => Mortar::API::Describe::STATUS_PROGRESS}), :status => 200}
      end
      response = @api.get_describe(describe_id)
      response.body['describe_id'].should == describe_id
      response.body['status'].should == Mortar::API::Describe::STATUS_PROGRESS
    end
  end
end