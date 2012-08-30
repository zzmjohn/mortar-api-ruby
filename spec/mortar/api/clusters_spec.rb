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
  
  context "clusters" do

    it "gets recent and running clusters" do
      Excon.stub({:method => :get, :path => "/v2/clusters"}) do |params|
        {:body => Mortar::API::OkJson.encode({"clusters" => [{'cluster_id' => '1', 'status_code' => 'running'}, {'cluster_id' => '2', 'status_code' => 'running'}]}), :status => 200}
      end
      response = @api.get_clusters()
      clusters = response.body["clusters"]
      clusters.nil?.should be_false
      clusters.length.should == 2
    end

  end
end