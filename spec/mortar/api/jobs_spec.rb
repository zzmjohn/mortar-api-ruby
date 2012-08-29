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
  
  context "jobs" do
    it "posts a job for an existing cluster" do
      job_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      project_name = "my_project"
      pigscript_name = "my_pigscript"
      git_ref = "e20395b8b06fbf52e86665b0660209673f311d1a"
      cluster_id = "f82c774f7ccd429e91db996838cb6c4a"
      parameters = {"my_first_param" => 1, "MY_SECOND_PARAM" => "TWO"}
      body = Mortar::API::OkJson.encode({"project_name" => project_name,
                                         "pigscript_name" => pigscript_name,
                                         "git_ref" => git_ref,
                                         "cluster_id" => cluster_id,
                                         "parameters" => parameters})
      Excon.stub({:method => :post, :path => "/v2/jobs", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'job_id' => job_id}), :status => 200}
      end
      response = @api.post_job_existing_cluster(project_name, pigscript_name, git_ref, cluster_id, :parameters => parameters)
      response.body['job_id'].should == job_id
    end

    it "posts a job for a new cluster, defaulting to keep_alive of true" do
      job_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      project_name = "my_project"
      pigscript_name = "my_pigscript"
      git_ref = "e20395b8b06fbf52e86665b0660209673f311d1a"
      cluster_size = 5
      body = Mortar::API::OkJson.encode({"project_name" => project_name,
                                         "pigscript_name" => pigscript_name,
                                         "git_ref" => git_ref,
                                         "cluster_size" => cluster_size,
                                         "keep_alive" => true,
                                         "parameters" => {}})
      Excon.stub({:method => :post, :path => "/v2/jobs", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'job_id' => job_id}), :status => 200}
      end
      response = @api.post_job_new_cluster(project_name, pigscript_name, git_ref, cluster_size)
      response.body['job_id'].should == job_id
    end
    
    it "accepts keep_alive of false" do
      job_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      project_name = "my_project"
      pigscript_name = "my_pigscript"
      git_ref = "e20395b8b06fbf52e86665b0660209673f311d1a"
      cluster_size = 5
      body = Mortar::API::OkJson.encode({"project_name" => project_name,
                                         "pigscript_name" => pigscript_name,
                                         "git_ref" => git_ref,
                                         "cluster_size" => cluster_size,
                                         "keep_alive" => false,
                                         "parameters" => {}})
      Excon.stub({:method => :post, :path => "/v2/jobs", :body => body}) do |params|
        {:body => Mortar::API::OkJson.encode({'job_id' => job_id}), :status => 200}
      end
      response = @api.post_job_new_cluster(project_name, pigscript_name, git_ref, cluster_size, :keepalive => false)
      response.body['job_id'].should == job_id
    end
    
    it "gets a job" do
      job_id = "7b93e4d3ab034188a0c2be418d3d24ed"
      status = Mortar::API::Jobs::STATUS_RUNNING
      Excon.stub({:method => :get, :path => "/v2/jobs/7b93e4d3ab034188a0c2be418d3d24ed"}) do |params|
        {:body => Mortar::API::OkJson.encode({'job_id' => job_id, 'status' => status}), :status => 200}
      end
      response = @api.get_job(job_id)
      response.body['job_id'].should == job_id
      response.body['status'].should == status
    end

    it "gets recent and running jobs" do
      Excon.stub({:method => :get, :path => "/v2/jobs"}) do |params|
        {:body => Mortar::API::OkJson.encode({"jobs" => [{'job_id' => '1', 'status' => 'running'}, {'job_id' => '2', 'status' => 'running'}]}), :status => 200}
      end
      response = @api.get_jobs(0, 10)
      jobs = response.body["jobs"]
      jobs.nil?.should be_false
      jobs.length.should == 2
    end

  end
end