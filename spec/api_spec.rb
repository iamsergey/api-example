require 'spec_helper'

RSpec.describe 'API' do
  before do
    Hotel.truncate
  end

  describe 'get /api/v1/hotels/:id' do
    it 'should respond with correct json' do
      hotel = Hotel.create name: 'TestHotel', address: 'TestAddress', accommodation_type: 'hotel'

      get "/api/v1/hotels/#{hotel.id}"

      response = JSON.parse(last_response.body).symbolize_keys
      expect(response).to eq id: hotel.id, name: 'TestHotel', address: 'TestAddress', accommodation_type: 'hotel'
    end

    it 'should respond with 404 if hotel does not exist' do
      get '/api/v1/hotels/123123'

      expect(last_response).to be_not_found
    end
  end

  describe 'post /api/v1/hotels' do
    it 'should update and respond with correct json' do
      expect {
        post "/api/v1/hotels", name: 'NewName', address: 'NewAddress', accommodation_type: 'villa'
      }.to change { Hotel.count }.by(1)

      hotel = Hotel.last
      response = JSON.parse(last_response.body).symbolize_keys
      expect(response).to eq id: hotel.id, name: 'NewName', address: 'NewAddress', accommodation_type: 'villa'
      expect(hotel.to_hash).to eq id: hotel.id, name: 'NewName', address: 'NewAddress', accommodation_type: 'villa'
    end

    it 'should respond with 404 if hotel does not exist' do
      put '/api/v1/hotels/123123', name: 'NameUpdated'

      expect(last_response).to be_not_found
    end
  end

  describe 'put /api/v1/hotels/:id' do
    it 'should update and respond with correct json' do
      hotel = Hotel.create name: 'TestHotel', address: 'TestAddress', accommodation_type: 'hotel'

      put "/api/v1/hotels/#{hotel.id}", name: 'NameUpdated', address: 'AddressUpdated', accommodation_type: 'villa'

      response = JSON.parse(last_response.body).symbolize_keys
      expect(response).to eq id: hotel.id, name: 'NameUpdated', address: 'AddressUpdated', accommodation_type: 'villa'
      expect(hotel.reload.to_hash).to eq id: hotel.id, name: 'NameUpdated', address: 'AddressUpdated', accommodation_type: 'villa'
    end

    it 'should respond with 404 if hotel does not exist' do
      put '/api/v1/hotels/123123', name: 'NameUpdated'

      expect(last_response).to be_not_found
    end
  end

  describe 'delete /api/v1/hotels/:id' do
    it 'should delete and respond with correct json' do
      hotel = Hotel.create name: 'TestHotel', address: 'TestAddress', accommodation_type: 'hotel'

      delete "/api/v1/hotels/#{hotel.id}"

      response = JSON.parse(last_response.body).symbolize_keys
      expect(response).to eq id: hotel.id, name: 'TestHotel', address: 'TestAddress', accommodation_type: 'hotel'
      expect(Hotel[hotel.id]).not_to be
    end

    it 'should respond with 404 if hotel does not exist' do
      delete '/api/v1/hotels/123123'

      expect(last_response).to be_not_found
    end
  end

  describe 'get /api/v1/hotels' do
    it 'should return all hotels if no limit or offset specified' do
      hotel1 = Hotel.create name: 'TestHotel1', address: 'TestAddress1', accommodation_type: 'hotel'
      hotel2 = Hotel.create name: 'TestHotel2', address: 'TestAddress2', accommodation_type: 'hotel'

      get "/api/v1/hotels"

      response = JSON.parse(last_response.body).map(&:symbolize_keys)
      expect(response.count).to eq 2
      expect(response).to include id: hotel1.id, name: 'TestHotel1', address: 'TestAddress1', accommodation_type: 'hotel'
      expect(response).to include id: hotel2.id, name: 'TestHotel2', address: 'TestAddress2', accommodation_type: 'hotel'
    end

    it 'should apply limit and offset if specified' do
      hotel1 = Hotel.create name: 'TestHotel1', address: 'TestAddress1', accommodation_type: 'hotel'
      hotel2 = Hotel.create name: 'TestHotel2', address: 'TestAddress2', accommodation_type: 'hotel'

      get "/api/v1/hotels?limit=1&offset=1"

      response = JSON.parse(last_response.body).map(&:symbolize_keys)
      expect(response.count).to eq 1
      expect(response).to include id: hotel1.id, name: 'TestHotel1', address: 'TestAddress1', accommodation_type: 'hotel'
      expect(response).not_to include id: hotel2.id, name: 'TestHotel2', address: 'TestAddress2', accommodation_type: 'hotel'
    end

    it 'should respond with blank json if no hotels found' do
      get '/api/v1/hotels'

      response = JSON.parse(last_response.body)
      expect(response).to be_blank
    end
  end

  describe 'get /api/v1/hotels/search' do
    it 'should find hotel by name' do
      hotel1 = Hotel.create name: 'Golden Plaza', address: 'TestAddress1', accommodation_type: 'hotel'
      hotel2 = Hotel.create name: 'Other Plaza', address: 'TestAddress2', accommodation_type: 'hotel'

      get "/api/v1/hotels/search?q=Olden"

      response = JSON.parse(last_response.body).map(&:symbolize_keys)
      expect(response.count).to eq 1
      expect(response).to include id: hotel1.id, name: 'Golden Plaza', address: 'TestAddress1', accommodation_type: 'hotel'
      expect(response).not_to include id: hotel2.id, name: 'Other Plaza', address: 'TestAddress2', accommodation_type: 'hotel'
    end

    it 'should apply limit and offset if specified' do
      hotel1 = Hotel.create name: 'TestHotel1', address: 'Red square, Moscow', accommodation_type: 'hotel'
      hotel2 = Hotel.create name: 'TestHotel2', address: 'Center, Amsterdam', accommodation_type: 'hotel'

      get "/api/v1/hotels/search?q=mOScow"

      response = JSON.parse(last_response.body).map(&:symbolize_keys)
      expect(response.count).to eq 1
      expect(response).to include id: hotel1.id, name: 'TestHotel1', address: 'Red square, Moscow', accommodation_type: 'hotel'
      expect(response).not_to include id: hotel2.id, name: 'TestHotel2', address: 'Center, Amsterdam', accommodation_type: 'hotel'
    end

    it 'should respond with blank json if no hotels found' do
      get '/api/v1/hotels/search?q=doesnotexist'

      response = JSON.parse(last_response.body)
      expect(response).to be_blank
    end
  end
end
