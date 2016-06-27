require 'rack'
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative '../api'

module RackHelper
  include Rack::Test::Methods

  def app
    Api::Application
  end
end

RSpec.configure do |config|
  config.include RackHelper
  config.before(:suite) do
    Database.migrate!
    Hotel.set_dataset(:hotels)
  end
end
