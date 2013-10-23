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

  context "config" do
    it "puts config vars" do
      project_name = "my_project"
      config_vars = {"a" => "foo", "B" => "BAR"}
      body = Mortar::API::OkJson.encode({"project_name" => project_name,
                                         "config" => config_vars})
      Excon.stub({:method => :put, :path => "/v2/config", :body => body}) do |params|
        {:body => "", :status => 200}
      end
      response = @api.put_config_vars(project_name, config_vars)
      response.body.should == ''
    end
    
    it "gets config vars" do
      project_name = "my_project"
      Excon.stub({:method => :get, :path => "/v2/config"}) do |params|
        {:body => Mortar::API::OkJson.encode({"project_name" => project_name, 
                                              "config" => {"a" => "foo", "B" => "BAR"}}), 
         :status => 200}
      end
      response = @api.get_config_vars(project_name)
      config_vars = response.body["config"]
      config_vars["a"].should == "foo"
      config_vars["B"].should == "BAR"
    end
    
    it "unset a config var" do
      project_name = "my_project"
      var_name = "MY_VAR needs escaping"
      Excon.stub({:method => :delete, :path => "/v2/config/MY_VAR+needs+escaping"}) do |params|
        {:body => "", :status => 200}
      end
      response = @api.delete_config_var(project_name, var_name)
      config_vars = response.body.should == ""
    end
  end
  
end