require "rubygems"
require "excon"
Excon.defaults[:mock] = true

require "rspec"
require "rr"

RSpec.configure do |config|
  config.mock_with :rr
  config.color_enabled = true
  config.order = 'rand'
  config.after { RR.reset }
end
