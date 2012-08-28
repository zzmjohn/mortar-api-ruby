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
  
  context "validate" do
    it "posts a validate" do
      validate_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      project_name = "my_project"
      pigscript_name = "my_pigscript"
      git_ref = "e20395b8b06fbf52e86665b0660209673f311d1a"
      parameters = {"key" => "value"}
      body = Mortar::API::OkJson.encode({"project_name" => project_name,
                                         "pigscript_name" => pigscript_name,
                                         "git_ref" => git_ref,
                                         "parameters" => parameters})
      Excon.stub({:method => :post, :path => "/v2/validates", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'validate_id' => validate_id}), :status => 200}
      end
      response = @api.post_validate(project_name, pigscript_name, git_ref, :parameters => parameters)
      response.body['validate_id'].should == validate_id
    end
    
    it "gets a validate" do
      validate_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      Excon.stub({:method => :get, :path => "/v2/validates/7b93e4d3ab034188a0c2be418d3d24ed"}) do |params|
        {:body => Mortar::API::OkJson.encode({'validate_id' => validate_id, 'status' => Mortar::API::Validate::STATUS_PROGRESS}), :status => 200}
      end
      response = @api.get_validate(validate_id)
      response.body['validate_id'].should == validate_id
      response.body['status'].should == Mortar::API::Validate::STATUS_PROGRESS
    end
  end
end