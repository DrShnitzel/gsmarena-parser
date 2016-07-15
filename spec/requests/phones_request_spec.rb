describe '/api/phones' do
  before :all do
    VCR.use_cassette('api_phones') do
      get '/api/phones?brand_url=acer-phones-59.php'
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
  it 'it grabs phones from all pages' do
    expect(resp.size).to eq 96
  end
end
