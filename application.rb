require 'sinatra/base'
require './app/gsmarena_parser'

class Application < Sinatra::Base
  set :public_folder, 'public'

  get '/' do
    redirect '/index.html'
  end

  get '/api/brands' do
    respond_with!(200, parser.brands)
  end

  get '/api/phones' do
    respond_with!(200, parser.phones)
  end

  get '/api/phone' do
    respond_with!(200, parser.phone)
  end

  get '/api/search' do
    respond_with!(200, parser.search_phones)
  end

  private

  def parser
    # NOTE other parsers may be pasted here
    @parser ||= GsmarenaParser.new(params)
    @parser
  end

  def respond_with!(status_code, body = {})
    status status_code
    content_type :json
    halt body.to_json
  end
end
