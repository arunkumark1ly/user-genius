require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe FetchUsersJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    let(:user_data) do
      {
        'login' => {'uuid' => '143'},
        'gender' => 'male',
        'name' => {"last"=>"Kandasamy", "first"=>"ArunKumar", "title"=>"Mr"},
        'location' => {"city"=>"Bangalore", "state"=>"Karnataka", "country"=>"India", "postcode"=>560068},
        'dob' => {'age' => 38}
      }
    end

    let(:response) { instance_double(HTTParty::Response, success?: true, parsed_response: {'results' => [user_data]}) }

    before do
      allow(HTTParty).to receive(:get).and_return(response)
      allow($redis).to receive(:set)
    end

    it 'fetches users and creates or updates them in the database' do
      expect { FetchUsersJob.new.perform }.to change(User, :count).by(1)
      user = User.last
      expect(user.uuid).to eq('143')
      expect(user.gender).to eq('male')
      expect(user.full_name_with_title).to eq('Mr ArunKumar Kandasamy')
      expect(user.location).to eq({"city"=>"Bangalore", "state"=>"Karnataka", "country"=>"India", "postcode"=>560068})
      expect(user.age).to eq(38)
    end

    it 'updates gender counts in Redis' do
      FetchUsersJob.new.perform
      expect($redis).to have_received(:set).with('male', '1')
      expect($redis).to have_received(:set).with('female', '0')
    end

    it 'logs an error if the API request fails' do
      allow(response).to receive(:success?).and_return(false)
      allow(response).to receive(:body).and_return('error message')
      expect(Rails.logger).to receive(:error).with('Failed to fetch users: error message')
      FetchUsersJob.new.perform
    end
  end
end
