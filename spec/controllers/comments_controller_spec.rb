require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:category) { create(:category) }
  let(:lesson) { create(:lesson, author: user, category:) }
  let(:comments_url) { "/categories/#{category.id}/lessons/#{lesson.id}/comments" }

  let(:token) do
    JsonWebToken.encode(name: user.name, email: user.email,
                        description: user.description, phone: user.phone,
                        gender: user.gender, birthday: user.birthday.to_s,
                        admin: user.admin_type, exp: 3.hours.from_now.to_i)
  end

  let(:token2) do
    JsonWebToken.encode(name: user2.name, email: user2.email,
                        description: user2.description, phone: user2.phone,
                        gender: user2.gender, birthday: user2.birthday.to_s,
                        admin: user2.admin_type, exp: 3.hours.from_now.to_i)
  end

  before do
    create_list(:comment, 5, user:, lesson:)
  end

  let(:params) do
    {
      body: 'Comment',
      user: user.id,
      lesson: lesson.id
    }
  end

  shared_examples 'Checks that the request is successful' do
    it 'is success http code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /comments' do
    context 'when all records are requested' do
      before { get comments_url, headers: { 'Authorization': "Bearer #{token}" }, as: :json }
      include_examples 'Checks that the request is successful'

      it 'returns all lessons' do
        expect(JSON.parse(response.body)['records'].count).to eq 5
      end
    end
  end

  describe 'POST /comments' do
    context 'when params are valid' do
      it 'creates comment' do
        expect { post comments_url, params:, headers: { 'Authorization': "Bearer #{token}" }, as: :json }
          .to change(Comment, :count).by(1)
      end
    end

    context 'when params are invalid' do
      let!(:invalid_params) do
        {
          user: user.id
        }
      end

      it 'returns an error 400' do
        post comments_url, params: invalid_params, headers: { 'Authorization': "Bearer #{token}" }, as: :json
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when record exist' do
      it 'deletes record' do
        expect do
          delete "#{comments_url}/#{Comment.all.sample.id}", headers: { 'Authorization': "Bearer #{token}" }, as: :json
        end.to change(Comment, :count).by(-1)
      end
    end

    context 'when record doesnt exist' do
      before { delete "#{comments_url}/#{Comment.all.sample.id}", headers: { 'Authorization': "Bearer #{token2}" },
                      as: :json }
      it 'returns an error 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH update' do
    let!(:comment) { create(:comment, user:, lesson:) }

    context 'when params are valid' do
      let(:param)  do
        {
          body: 'Hello',
          user: user.id,
          lesson: lesson.id
        }
      end

      before do
        put "#{comments_url}/#{comment.id}", params: param, headers: { 'Authorization': "Bearer #{token}" }, as: :json
      end

      it 'responds with success code' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds correct comment body' do
        expect(JSON.parse(response.body)['body']).to eq param[:body]
      end
    end

    context 'when params are invalid' do
      let(:update_params) { { user_id: '5' } }

      before do
        put "#{comments_url}/#{comment.id}", params: update_params, headers: { 'Authorization': "Bearer #{token}" },
            as: :json
      end

      it 'returns an error 422' do
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end

end
