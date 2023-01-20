require 'rails_helper'

RSpec.describe CategoriesController, type: :request do
  let(:categories_url) { '/categories' }
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin_type: true) }

  let(:admin_token) do
    JsonWebToken.encode(name: admin.name, email: admin.email,
                        description: admin.description, phone: admin.phone,
                        gender: admin.gender, birthday: admin.birthday.to_s,
                        admin: admin.admin_type, exp: 3.hours.from_now.to_i)
  end
  let(:user_token) do
    JsonWebToken.encode(name: user.name, email: user.email,
                        description: user.description, phone: user.phone,
                        gender: user.gender, birthday: user.birthday.to_s,
                        admin: user.admin_type, exp: 3.hours.from_now.to_i)
  end

  before do
    create_list(:category, 5)
  end

  let(:params) do
    {
      name: 'Category name',
      description: 'Category description',
      status: 'active'
    }
  end

  shared_examples 'checks that the request is successful' do
    it 'is success http code' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /categories' do
    context 'when all records are requested' do
      before { get categories_path }
      include_examples 'checks that the request is successful'

      it 'returns all categories' do
        expect(JSON.parse(response.body)['records'].count).to eq 5
      end
    end
  end

  # describe 'GET /categories/{id}' do
  #
  #   # context 'when record exists' do
  #   #   before { get "#{categories_url}/#{category.id}" }
  #   #
  #   #   include_examples 'checks that the request is successful'
  #   # end
  #
  #   context 'when the request is invalid' do
  #     it 'returns an error 404' do
  #       get "#{categories_url}/abc"
  #       expect(response).to have_http_status(404)
  #     end
  #   end
  # end

  describe 'POST /categories' do
    context 'when params are valid' do
      it 'admin creates category' do
        expect { post categories_url, params:, headers: { 'Authorization': "Bearer #{admin_token}" } }
          .to change(Category, :count).by(1)
      end
    end

    context 'when params are invalid' do
      let!(:invalid_params) do
        {
          description: 'Category description'
        }
      end

      it 'returns an error 422' do
        post categories_url, params: invalid_params, headers: { 'Authorization': "Bearer #{admin_token}" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when params are valid' do
      before { post categories_url, params:, headers: { 'Authorization': "Bearer #{user_token}" } }

      it 'user creates category' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when record exist' do
      it 'admin deletes record' do
        expect do
          delete "#{categories_url}/#{Category.all.sample.id}", headers: { 'Authorization': "Bearer #{admin_token}" }
        end.to change(Category, :count).by(-1)
      end
    end

    context 'admin delete when record doesnt exist' do
      before do
        delete "#{categories_url}/#{Category.all.sample.id + 10}", headers: { 'Authorization': "Bearer #{admin_token}" }
      end
      it 'returns an error 404' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user delete' do
      before do
        delete "#{categories_url}/#{Category.all.sample.id}", headers: { 'Authorization': "Bearer #{user_token}" }
      end

      it 'user creates category' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when category has lesson' do
      let!(:category_1) { create(:category) }
      let!(:lesson_1) { create(:lesson, category_id: category_1.id) }

      before do
        delete "#{categories_url}/#{category_1.id}", headers: { 'Authorization': "Bearer #{admin_token}" }
      end

      it 'user creates category' do
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['error']).to eq("You can't delete this category")
      end
    end
  end

end