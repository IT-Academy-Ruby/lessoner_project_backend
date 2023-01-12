require 'rails_helper'

RSpec.describe LessonsController, type: :request do
  let(:lessons_url) { '/lessons' }
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:token) do
    JsonWebToken.encode(name: user.name, email: user.email,
                        description: user.description, phone: user.phone,
                        gender: user.gender, birthday: user.birthday.to_s,
                        admin: user.admin_type, exp: 3.hours.from_now.to_i)
  end

  before do
    create_list(:lesson, 5, author: user, category:)
  end

  let(:params) do
    {
      title: 'Lesson name',
      description: 'Lesson description',
      video_link: 'http://video.com/my-video',
      status: 'active',
      author_id: user.id,
      category_id: category.id,
      image_size: 900,
      image_name: 'image.jpg'
    }
  end
  shared_examples 'Сhecks that the request is successful' do
    it 'is success http code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /lessons' do
    context 'when all records are requested' do
      before { get lessons_path }
      include_examples 'Сhecks that the request is successful'

      it 'returns all lessons' do
        expect(JSON.parse(response.body)['records'].count).to eq 5
      end
    end
  end

  describe 'GET /lessons/{id}' do
    context 'when record exists' do
      before { get "#{lessons_url}/#{Lesson.all.sample.id}" }

      include_examples 'Сhecks that the request is successful'
    end

    context 'when the request is invalid' do
      it 'returns an error 404' do
        get "#{lessons_url}/abc"
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /lessons' do
    context 'when params are valid' do
      it 'creates lesson' do
        expect { post lessons_url, params:, headers: { 'Authorization': "Bearer #{token}" } }
          .to change(Lesson, :count).by(1)
      end
    end

    context 'when params are invalid' do
      let!(:invalid_params) do
        {
          description: 'Lesson description',
          video_link: 'http://video.com/my-video',
          author_id: user.id,
          category_id: category.id
        }
      end

      it 'returns an error 422' do
        post lessons_url, params: invalid_params, headers: { 'Authorization': "Bearer #{token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when record exist' do
      it 'deletes record' do
        expect do
          delete "#{lessons_url}/#{Lesson.all.sample.id}", headers: { 'Authorization': "Bearer #{token}" }
        end.to change(Lesson, :count).by(-1)
      end
    end

    context 'when record doesnt exist' do
      before { delete "#{lessons_url}/#{Lesson.all.sample.id + 10}", headers: { 'Authorization': "Bearer #{token}" } }
      it 'returns an error 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PATCH update' do
    let(:lesson) { create(:lesson, author: user, category:) }

    context 'when params are valid' do
      let(:rating_params) { { rating: 5 } }

      before do
        put "#{lessons_url}/#{lesson.id}", params: rating_params, headers: { 'Authorization': "Bearer #{token}" }
      end

      it 'responds with success code' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds correct lessons rating' do
        expect(JSON.parse(response.body)['rating']).to eq rating_params[:rating]
      end
    end

    context 'when params are invalid' do
      let(:update_params) { { category_id: '3' } }

      before do
        put "#{lessons_url}/#{lesson.id}", params: update_params, headers: { 'Authorization': "Bearer #{token}" }
      end

      it 'returns an error 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
