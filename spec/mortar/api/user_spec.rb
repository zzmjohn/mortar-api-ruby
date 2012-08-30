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
  
  context "user" do
    it "gets logged in user" do
      user_id = "b480950f1fbf4d8a96235038d6badb7d"
      email = "fake@nowhere.com"
      Excon.stub({:method => :get, :path => "/v2/user"}) do |params|
        {:body => Mortar::API::OkJson.encode({"user_id" => user_id, "user_email" => email}), :status => 200}
      end
      response = @api.get_user()
      response.body["user_id"].should == user_id
      response.body["user_email"].should == email
    end
    
    it "errors when no user is logged in" do
      Excon.stub({:method => :get, :path => "/v2/user"}) do |params|
        {:status => 401}
      end
      expect {@api.get_user()}.to raise_error(Mortar::API::Errors::Unauthorized)
    end

    it "updates user successfully" do
      user_id = "somebiglongid"
      github_username = "some_github_name"
      task_id = "some1task2id"

      body = Mortar::API::OkJson.encode({"github_username" => github_username})
      Excon.stub({:method => :put, :path => "/v2/user/#{user_id}", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({"task_id" => task_id}), :status => 200}
      end

      response = @api.update_user(user_id, {"github_username" => github_username})
      response.body['task_id'].should == task_id
    end

  end
end