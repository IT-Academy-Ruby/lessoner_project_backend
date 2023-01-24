require 'rails_helper'

RSpec.describe MyStudiosController, type: :request do
  let(:user) { create(:user) }
  let(:token) do
    JsonWebToken.encode(name: user.name, email: user.email,
                        description: user.description, phone: user.phone,
                        gender: user.gender, birthday: user.birthday.to_s,
                        admin: user.admin_type, exp: 3.hours.from_now.to_i)
  end

  before do
    create_list(:lesson, 5, author: user)
  end


  describe 'GET /my_studio/lessons' do
    context 'when all records are requested' do
      before { get '/my_studio/lessons', headers: { 'Authorization': "Bearer #{token}" }, as: :json }

      it 'returns all lessons' do
        expect(JSON.parse(response.body)['records'].count).to eq 5
        expect(response).to have_http_status(200)
      end
    end
  end
end
