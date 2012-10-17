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
  
  context "fixtures" do
        
    it "gets a fixture" do
      account_id = "123456780aaaaaa123456780aaaaaabb"
      project_name = "MyProject"
      project_id = "aaaaasssss"
      fixture_id = "12345123412abcd12345123412abcdef"
      fixture = {'name' => "Some fixture",
                 'fixture_id' => fixture_id,
                 'account_id' => account_id,
                 'project_id' => project_id,
                 'status_code' => Mortar::API::Fixtures::STATUS_CREATED,
                 'status_description' => "Some Status Description",
                 'sample_s3_urls' => [ {'url' => "https://some_url_1", 
                                        'name' => "url1"}, 
                                       {'url' => "https://some_url_2",
                                        'name' => "url2"}]
                }
      Excon.stub({:method => :get, :path => "/v2/fixtures/#{fixture_id}"}) do |params|
        {:body => Mortar::API::OkJson.encode(fixture),
         :status => 200}
      end
      response = @api.get_fixture(fixture_id)
      response.body['name'].should == fixture['name']
      response.body['status'].should == fixture['status']
      response.body['sample_s3_urls'].count.should == 2
    end
    
    it "posts a limit fixture" do
      fixture_name = "some_fixture"
      s3_url = "some_s3_url"
      num_rows = 100
      project_name = "ProjectName"
      fixture_id = "12345123412abcd12345123412abcdef"

      body = Mortar::API::OkJson.encode({"fixture_name" => fixture_name,
                                         "project_name" => project_name,
                                         "s3_url" => s3_url,
                                         "num_rows" => num_rows})
      Excon.stub({:method => :post, :path => "/v2/fixtures", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({"fixture_id" => fixture_id}), :status => 200}
      end
      response = @api.post_fixture_limit(project_name, fixture_name, s3_url, num_rows)
      response.body['fixture_id'].should == fixture_id
    end

  end
end