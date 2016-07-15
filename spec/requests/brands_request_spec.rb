describe '/api/brands' do
  before :all do
    VCR.use_cassette('api_brands') do
      get '/api/brands'
    end
  end
  it 'returns 200' do
    expect(last_response.status).to eq 200
  end
  it 'responds with array' do
    expect(resp.class).to eq Array
  end
  it 'has correct format of array entries' do
    resp.each do |entry|
      expect(entry.key?('title')).to be true
      expect(entry.key?('href')).to be true
    end
  end
  it 'has all brands' do
    expect(resp.size).to eq 108
  end
end
