require "excon"
require "securerandom"
require "uri"
require "zlib"

__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), ".."))
unless $LOAD_PATH.include?(__LIB_DIR__)
  $LOAD_PATH.unshift(__LIB_DIR__)
end

require "mortar/api/vendor/okjson"


require "mortar/api/basicauth"
require "mortar/api/errors"
require "mortar/api/version"

require "mortar/api/illustrate"
require "mortar/api/jobs"
require "mortar/api/login"
require "mortar/api/user"

srand

module Mortar
  class API
    
    include Mortar::API::BasicAuth
    
    attr_reader :connection
    
    def initialize(options={})
      user = options.delete(:user)
      api_key = options.delete(:api_key) || ENV['MORTAR_API_KEY']
      options = {
        :headers  => {},
        :host     => 'api.mortardata.com',
        :scheme   => 'https'
      }.merge(options)
      options[:headers] = {
        'Accept'                => 'application/json',
        'Accept-Encoding'       => 'gzip',
        'Content-Type'          => 'application/json',
        #'Accept-Language'       => 'en-US, en;q=0.8',
        'Authorization'         => basic_auth_authorization_header(user, api_key),
        'User-Agent'            => "mortar-api-ruby/#{Mortar::API::VERSION}",
        'X-Ruby-Version'        => RUBY_VERSION,
        'X-Ruby-Platform'       => RUBY_PLATFORM
      }.merge(options[:headers])
      @connection = Excon.new("#{options[:scheme]}://#{options[:host]}", options)
    end

    def request(params, &block)
      begin
        response = @connection.request(params, &block)
      rescue Excon::Errors::HTTPStatusError => error
        klass = case error.response.status
          when 401 then Mortar::API::Errors::Unauthorized
          when 402 then Mortar::API::Errors::VerificationRequired
          when 403 then Mortar::API::Errors::Forbidden
          when 404 then Mortar::API::Errors::NotFound
          when 408 then Mortar::API::Errors::Timeout
          when 422 then Mortar::API::Errors::RequestFailed
          when 423 then Mortar::API::Errors::Locked
          when /50./ then Mortar::API::Errors::RequestFailed
          else Mortar::API::Errors::ErrorWithResponse
        end

        reerror = klass.new(error.message, error.response)
        reerror.set_backtrace(error.backtrace)
        raise(reerror)
      end

      if response.body && !response.body.empty?
        if response.headers['Content-Encoding'] == 'gzip'
          response.body = Zlib::GzipReader.new(StringIO.new(response.body)).read
        end
        begin
          response.body = Mortar::API::OkJson.decode(response.body)
        rescue
          # leave non-JSON body as is
        end
      end

      # reset (non-persistent) connection
      @connection.reset

      response
    end

    def versioned_path(resource)
      no_slash_resource = resource.start_with?("/") ? resource[1,resource.size] : resource
      "/v#{SERVER_API_VERSION}/#{no_slash_resource}"
    end
    
    protected

    def json_encode(object)
      Mortar::API::OkJson.encode(object)
    end

    def escape(string)
      CGI.escape(string).gsub('.', '%2E')
    end

  end
end
