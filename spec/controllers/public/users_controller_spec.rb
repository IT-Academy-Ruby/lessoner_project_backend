require 'rails_helper'

RSpec.describe Public::UsersController, type: :request do
  let!(:user) { create(:user, name: 'username', email: 'user_email@gmail.com') }
  let(:check_username_url) { '/check_username' }
  let(:check_email_url) { '/check_email' }

  shared_examples 'checks that the request is successful' do
    it 'is success http code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /check_username' do
    context 'when username exists' do
      before { get check_username_url, params: { name: 'username' } }
      include_examples 'checks that the request is successful'

      it 'returns true' do
        expect(JSON.parse(response.body)['username_exists']).to eq(true)
      end
    end

    context 'when username doesnt exist' do
      before { get check_username_url, params: { name: 'username1' } }
      include_examples 'checks that the request is successful'

      it 'returns false' do
        expect(JSON.parse(response.body)['username_exists']).to eq(false)
      end
    end
  end

  describe 'GET /check_email' do
    context 'when email exists' do
      before { get check_email_url, params: { email: 'user_email@gmail.com' } }
      include_examples 'checks that the request is successful'

      it 'returns true' do
        expect(JSON.parse(response.body)['email_exists']).to eq(true)
      end
    end

    context 'when email doesnt exist' do
      before { get check_email_url, params: { email: 'user_email1@gmail.com' } }
      include_examples 'checks that the request is successful'

      it 'returns false' do
        expect(JSON.parse(response.body)['email_exists']).to eq(false)
      end
    end
  end
end


