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
  
  include Mortar::API::BasicAuth
  
  context "base methods" do
    it "creates versioned API paths" do
      api = Mortar::API.new
      api.versioned_path("/illustrate/123").should == "/v2/illustrate/123"
      api.versioned_path("illustrate/123").should == "/v2/illustrate/123"
    end
  end
  
  context "api initialization" do
    it "handles token auth properly" do
      email = "nobody@nowhere.com"
      api_key = "6db6Wm9ZUeCl0NVNdkhptksCh0T9i6bv1dYZXaKz"
      api = Mortar::API.new(:user => email, :api_key => api_key)
      authorization = api.connection.data[:headers]['Authorization']
      authorization.nil?.should be_false
      authorization.should == basic_auth_authorization_header(email, api_key)
    end
  end
end