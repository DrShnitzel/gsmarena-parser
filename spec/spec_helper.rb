require './application'
require_relative 'support/vcr_initializer'
require 'rack/test'

include Rack::Test::Methods

ENV['RACK_ENV'] = 'testing'
Application.show_exceptions = false

def app
  Application
end

def resp
  JSON.parse(last_response.body)
end
