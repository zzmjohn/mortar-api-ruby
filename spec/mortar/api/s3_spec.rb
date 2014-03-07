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
  context "s3 use default expire time" do
    it "gets a bunch of urls" do
      bucket = "bucket"
      key = "key"
      query = {
        :bucket => bucket,
        :key => key,
        :expire_time => 120
      }
      urls= Array.new
      Excon.stub({:method => :get, :path => "/v2/s3", :query => query}) do |params|
        {:body => Mortar::API::OkJson.encode({'urls' => urls}), :status =>200}
      end

      response = @api.get_s3_urls(bucket, key)
      response.body['urls'].should == urls
      
    end
    it "gets a bunch of urls" do
      bucket = "bucket"
      key = "key"
      query = {
        :bucket => bucket,
        :key => key,
        :expire_time => 1000
      }
      urls= Array.new
      Excon.stub({:method => :get, :path => "/v2/s3", :query => query}) do |params|
        {:body => Mortar::API::OkJson.encode({'urls' => urls}), :status =>200}
      end

      response = @api.get_s3_urls(bucket, key, 1000)
      response.body['urls'].should == urls
      
    end
  end


end

