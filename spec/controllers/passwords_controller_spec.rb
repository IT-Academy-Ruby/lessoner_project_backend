require 'rails_helper'

RSpec.describe PasswordsController, type: :request do
  let(:forgot_url) { '/password/forgot' }
  let(:reset_url) { '/password/reset' }
  let(:message) { "We've sent a link to restore access to your account to the address test@mail.com" }

  let(:email) { 'test@mail.com' }
  let!(:user) { create(:user, email: 'test@mail.com') }

  let(:params) do
    {
      email:
    }
  end

  describe 'POST /password/forgot' do
    context 'when request is successful' do
      before { post forgot_url, params:, as: :json }

      it 'returns success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['alert']).to eq message
      end
    end

    context 'if user is not present' do
      let(:another_params) do
        {
          email: 'another_user@mail.com'
        }
      end

      before { post forgot_url, params: another_params, as: :json }
      it 'returns not found error' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User is not found. Please enter a valid email address')
      end
    end

    context 'if email is blank' do
      let(:blank_params) do
        {
          email: nil
        }
      end

      before { post forgot_url, params: blank_params, as: :json }
      it 'returns error' do
        expect(JSON.parse(response.body)['error']).to eq('Email not present')
      end
    end
  end

  describe 'POST /password/reset' do
    let!(:user) { create(:user, password_reset_token: '123456789123t098pb', password_reset_sent_at: Time.now.utc.to_s) }

    let(:params) do
      {
        token: '123456789123t098pb',
        password: '123456'
      }
    end
    context 'when request is successful' do
      before { post reset_url, params:, as: :json }

      it 'returns success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq('ok')
      end
    end

    context 'when token is not valid' do
      let(:invalid_params) do
        {
          token: '123456789123t098pbq',
          password: '123456'
        }
      end
      before { post reset_url, params: invalid_params, as: :json }

      it 'returns success response' do
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Link not valid or expired. Try generating a new link.')
      end
    end

    context 'when response is not success' do
      let(:invalid_params) do
        {
          token: '123456789123t098pb',
          password: '123'
        }
      end

      before { post reset_url, params: invalid_params, as: :json }

      it 'returns success response' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to be_present
      end
    end
  end
end



