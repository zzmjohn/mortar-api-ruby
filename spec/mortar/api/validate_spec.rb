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
  
  context "validate" do
    it "posts a validate" do
      validate_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      project_name = "my_project"
      pigscript_name = "my_pigscript"
      project_script_path = "pigscripts/my_pigscript/"
      git_ref = "e20395b8b06fbf52e86665b0660209673f311d1a"
      parameters = {"key" => "value"}
      body = Mortar::API::OkJson.encode({"project_name" => project_name,
                                         "pigscript_name" => pigscript_name,
                                         "project_script_path" => project_script_path,
                                         "git_ref" => git_ref, 
                                         "parameters" => parameters
                                         })
      Excon.stub({:method => :post, :path => "/v2/validates", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'validate_id' => validate_id}), :status => 200}
      end
      response = @api.post_validate(project_name, pigscript_name, git_ref, :parameters => parameters, :project_script_path => project_script_path)
      response.body['validate_id'].should == validate_id
    end

    it "posts a validate with set pig version" do
      validate_id = "7b93e4d3ab034188a0c2be418d3d24ee"
      project_name = "my_project"
      pigscript_name = "my_pigscript"
      git_ref = "e20395b8b06fbf52e86665b0660209673f311d1a"
      parameters = {"key" => "value"}
      pig_version = "0.12"
      body = Mortar::API::OkJson.encode({"project_name" => project_name,
                                         "pigscript_name" => pigscript_name,
                                         "git_ref" => git_ref, 
                                         "parameters" => parameters,
                                         "pig_version" => pig_version
                                         })
      Excon.stub({:method => :post, :path => "/v2/validates", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'validate_id' => validate_id}), :status => 200}
      end
      response = @api.post_validate(project_name, pigscript_name, git_ref, :parameters => parameters, :pig_version => pig_version)
      response.body['validate_id'].should == validate_id
    end
    
    it "gets a validate" do
      validate_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      Excon.stub({:method => :get, :path => "/v2/validates/7b93e4d3ab034188a0c2be418d3d24ed"}) do |params|
        {:body => Mortar::API::OkJson.encode({'validate_id' => validate_id, 'status' => Mortar::API::Validate::STATUS_PROGRESS}), :status => 200}
      end
      response = @api.get_validate(validate_id)
      response.body['validate_id'].should == validate_id
      response.body['status'].should == Mortar::API::Validate::STATUS_PROGRESS
    end
  end
end