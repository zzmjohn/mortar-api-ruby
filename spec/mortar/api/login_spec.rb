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
  
  include Mortar::API::BasicAuth
  
  before(:each) do
    @api = Mortar::API.new
  end
  
  after(:each) do
    Excon.stubs.clear
  end
  
  context "login" do
    it "logs in successfully" do
      email = "fake@nowhere.com"
      password = "fakepass"
      api_key = "6db6Wm9ZUeCl0NVNdkhptksCh0T9i6bv1dYZXaKz"
      Excon.stub({:method => :post, :path => "/v2/login"}) do |params|
        params[:headers]["Authorization"].should == basic_auth_authorization_header(email, password)
        {:body => Mortar::API::OkJson.encode({"api_key" => api_key}), :status => 200}
      end
      response = @api.post_login(email, password)
      response.body["api_key"].should == api_key
    end
    
    it "fails login with bad api_key" do
      Excon.stub({:method => :post, :path => "/v2/login"}) do |params|
        {:status => 401}
      end
      expect {@api.post_login("wronguser@fake.org", "wrongpass")}.to raise_error(Mortar::API::Errors::Unauthorized)
    end
    
  end
end