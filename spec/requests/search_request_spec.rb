describe '/api/search' do
  context 'when search is successeful' do
    before :all do
      VCR.use_cassette('api_search') do
        get '/api/search?text=sam'
      end
    end
    it 'returns 200' do
      expect(last_response.status).to eq 200
    end
    it 'responds with array' do
      expect(resp.class).to eq Array
    end
    it 'result is not empty' do
      expect(resp.empty?).to be false
    end
    it 'has correct format of array entries' do
      resp.each do |entry|
        expect(entry.key?('title')).to be true
        expect(entry.key?('href')).to be true
      end
    end
  end
  context 'when result should be empty' do
    before :all do
      VCR.use_cassette('api_search_empty') do
        get '/api/search?text=samhkdkhdokdfkgdfkkso'
      end
    end
    it 'returns 200' do
      expect(last_response.status).to eq 200
    end
    it 'responds with array' do
      expect(resp.class).to eq Array
    end
    it 'result is empty' do
      puts resp
      expect(resp.empty?).to be true
    end
  end
end
