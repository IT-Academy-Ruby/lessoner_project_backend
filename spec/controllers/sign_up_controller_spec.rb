require 'rails_helper'

RSpec.describe SignUpController, type: :request do
  let(:sign_up_url) { '/sign_up' }
  let(:login_url) { '/login' }

  let(:email) { 'test@mail.com' }
  let(:name) { 'test' }
  let(:gender) { 'male' }
  let(:phone) { '+375(44)355-35-34' }
  let(:birthday) { '2000-01-11' }
  let(:password) { '12345678' }

  let(:params) do
    {
      name:,
      phone:,
      gender:,
      email:,
      birthday:,
      password:
    }
  end

  describe 'POST /sign_up' do
    context 'when sign_up is successful' do
      before { post sign_up_url, params:, as: :json }

      it 'returns correct response' do
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['id']).to be_present
        expect(JSON.parse(response.body)['name']).to eq name
        expect(JSON.parse(response.body)['phone']).to eq phone
        expect(JSON.parse(response.body)['gender']).to eq gender
        expect(JSON.parse(response.body)['email']).to eq email
        expect(JSON.parse(response.body)['birthday']).to eq birthday
      end
    end

    context 'when params are invalid' do
      let(:invalid_params) do
        {
          name:,
          phone: '31345',
          gender:,
          email:,
          birthday:,
          password:
        }
      end

      before { post sign_up_url, params: invalid_params, as: :json }
      it 'returns an error' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST /login' do
    let(:params_login) do
      {
        email:,
        password:
      }
    end
    let!(:user) { create(:user, email_confirmed: true, email:, password:) }

    context 'when login is successful' do
      before { post login_url, params: params_login, as: :json }
      it 'returns success response' do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['jwt']).to be_present
      end
    end

    context 'when email is not confirmed' do
      before do
        user.email_confirmed = false
        user.save!
        post login_url, params: params_login, as: :json
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when login params are invalid' do
      let(:invalid_params_login) do
        {
          email: '313',
          password:
        }
      end
      before do
        post login_url, params: invalid_params_login, as: :json
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
