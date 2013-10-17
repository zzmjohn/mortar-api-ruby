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

require "spec_helper"
require "mortar/api"


describe Mortar::API do
  
  before(:each) do
    @api = Mortar::API.new
  end
  
  after(:each) do
    Excon.stubs.clear
  end
  
  context "redirect" do
    it "posts an illustrate and gets a redirect" do
      illustrate_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      project_name = "my_project"
      pigscript_name = "my_pigscript"
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
                                         "pig_version" => "0.9"})
      redirect_url = "some_redirect_url"
      redirect_message = "some_redirect_message"
      Excon.stub({:method => :post, :path => "/v2/illustrates", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'redirect' => redirect_url, 'error' => redirect_message}), :status => 200}
      end
       expect {@api.post_illustrate(project_name, pigscript_name, pigscript_alias, skip_pruning, git_ref, "0.9", :parameters => parameters)}.to raise_error(Mortar::API::Errors::Redirect)
    end
  end
end