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