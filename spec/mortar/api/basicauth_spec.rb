require "spec_helper"
require "mortar/api/basicauth"

describe Mortar::API::BasicAuth do
    
  include Mortar::API::BasicAuth
  
  context "basicauth" do
    it "gets basic auth headers" do
      user = "foo@bar.com"
      password = "mypassword"
      basic_auth_authorization_header(user, password).should == "Basic Zm9vQGJhci5jb206bXlwYXNzd29yZA=="
    end    
  end
end