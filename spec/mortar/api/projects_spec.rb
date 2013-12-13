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
  
  context "projects" do
    
    it "gets all projects" do
      project1 = {'name' => "Project 1",
                  'status' => Mortar::API::Projects::STATUS_ACTIVE,
                  'github_repo_name' => "Project-1"}
      project2 = {'name' => "Project 2",
                  'status' => Mortar::API::Projects::STATUS_ACTIVE,
                  'github_repo_name' => "Project-2"}
      
      Excon.stub({:method => :get, :path => "/v2/projects"}) do |params|
        {:body => Mortar::API::OkJson.encode({'projects' => [project1, project2]}),
         :status => 200}
      end
      response = @api.get_projects
      response.body['projects'][0]['name'].should == project1['name']
      response.body['projects'][1]['name'].should == project2['name']
      response.body['projects'][0]['status'].should == project1['status']
      response.body['projects'][1]['status'].should == project2['status']
    end
    
    it "gets a project" do
      project_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      project1 = {'name' => "Project 1",
                  'status' => Mortar::API::Projects::STATUS_ACTIVE,
                  'github_repo_name' => "Project-1",
                  '_id' => project_id}
      
      Excon.stub({:method => :get, :path => "/v2/projects/%s" % project_id}) do |params|
        {:body => Mortar::API::OkJson.encode(project1),
         :status => 200}
      end
      response = @api.get_project(project_id)
      response.body['name'].should == project1['name']
      response.body['status'].should == project1['status']
      response.body['github_repo_name'].should == project1['github_repo_name']
    end
    
    it "posts a project" do
      project_name = "my_new_project"
      project_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      body = Mortar::API::OkJson.encode({"project_name" => project_name, "is_private" => true})
      Excon.stub({:method => :post, :path => "/v2/projects", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'project_name' => project_name, "project_id" => project_id}), :status => 200}
      end
      response = @api.post_project(project_name)
      response.body['project_id'].should == project_id
      response.body['project_name'].should == project_name
    end

    it "posts a public project" do
      project_name = "my_new_project"
      project_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      body = Mortar::API::OkJson.encode({"project_name" => project_name, "is_private" => false})
      Excon.stub({:method => :post, :path => "/v2/projects", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'project_name' => project_name, "project_id" => project_id}), :status => 200}
      end
      response = @api.post_project(project_name, false)
      response.body['project_id'].should == project_id
      response.body['project_name'].should == project_name
    end
    
  end
end
