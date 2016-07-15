require 'sinatra/base'
require './app/gsmarena_parser'

class Application < Sinatra::Base
  set :public_folder, 'public'

  get '/' do
    redirect '/index.html'
  end

  get '/api/brands' do
    body = GsmarenaParser.new.brands
    respond_with!(200, body)
  end

  get '/api/phones' do
    body = GsmarenaParser.new(params).phones
    respond_with!(200, body)
  end

  get '/api/phone' do
    body = GsmarenaParser.new(params).phone
    respond_with!(200, body)
  end

  get '/api/search' do
    body = GsmarenaParser.new(params).search
    respond_with!(200, body)
  end

  private

  def respond_with!(status_code, body = {})
    status status_code
    content_type :json
    halt body.to_json
  end
end
