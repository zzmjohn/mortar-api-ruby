require "base64"
require "spec_helper"
require "mortar/api"


describe Mortar::API do
    
  context "base methods" do
    it "creates versioned API paths" do
      api = Mortar::API.new
      api.versioned_path("/illustrate/123").should == "/v2/illustrate/123"
      api.versioned_path("illustrate/123").should == "/v2/illustrate/123"
    end
  end
  
  context "api initialization" do
    it "handles basic auth properly" do
      user = "myuser"
      password = "mypassword"
      api = Mortar::API.new(:user => user, :password => password)
      authorization = api.connection.connection[:headers]['Authorization']
      authorization.nil?.should be_false
      encoded_pass = Base64.encode64("#{user}:#{password}").gsub("\n", '')
      puts api.connection.connection[:headers]
      authorization.should == "Basic #{encoded_pass}"
    end
  end
end