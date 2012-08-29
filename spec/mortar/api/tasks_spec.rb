require "spec_helper"
require "mortar/api"

describe Mortar::API do
  
  before(:each) do
    @api = Mortar::API.new
  end
  
  after(:each) do
    Excon.stubs.clear
  end
  
  context "tasks" do

    it "gets task" do
      task_id = "b480950f1fbf4d8a96235038d6badb7d"
      
      Excon.stub({:method => :get, :path => "/v2/tasks/#{task_id}"}) do |params|
        {:body => Mortar::API::OkJson.encode({"task_id" => task_id, "status_code" => "some_status"}), :status => 200}
      end
      response = @api.get_task(task_id)
      response.body["status_code"].should == "some_status"
    end

  end
end