describe '/api/phone' do
  before :all do
    VCR.use_cassette('api_phone') do
      get '/api/phone?phone_url=apple_iphone_se-7969.php'
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
      expect(entry.key?('value')).to be true
    end
  end
  it 'has all specs' do
    expect(resp.size).to eq 60
  end
end
