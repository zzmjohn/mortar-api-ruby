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
  end
end