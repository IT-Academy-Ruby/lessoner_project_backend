require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/users' do
    parameter name: 'page', in: :query, type: :integer, default: 1, required: false
    parameter name: 'items', in: :query, type: :integer, required: false
    parameter name: 'sort_field', in: :query, type: :string, required: false
    parameter name: 'sort_type', in: :query, type: :string, required: false

    get('list users') do
      tags 'Users'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1 },
            name: { type: :string, example: 'User name' },
            description: { type: :string, example: 'User description' },
            email: { type: :string, example: 'user@gmail.com' },
            avatar_url: { type: :string, example: 'https://lessoner.s3.amazonaws.com/image-url' },
            phone: { type: :string, example: '+375291234567' },
            gender: { type: :integer, example: 'male' },
            birthday: { type: :string, example: '2000-01-01' },
            created_at: { type: :string, example: '2022-12-01 14:11:33 +0300' }
          },
          required: %w[id name description email avatar_url phone gender birthday created_at]
        }
        run_test!
      end
    end
  end
  
  path '/users/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show user') do
      tags 'Users'
      produces 'application/json'
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 id: { type: :integer, minimum: 1 },
                 name: { type: :string, example: 'User name' },
                 description: { type: :string, example: 'User description' },
                 email: { type: :string, example: 'user@gmail.com' },
                 avatar_url: { type: :string, example: 'https://lessoner.s3.amazonaws.com/image-url' },
                 phone: { type: :string, example: '+375291234567' },
                 gender: { type: :integer, example: 'male' },
                 birthday: { type: :string, example: '2000-01-01' },
                 created_at: { type: :string, example: '2022-12-01 14:11:33 +0300' }
               },
               required: %w[id name description email avatar_url phone gender birthday created_at]
        let(:id) { '3' }

        run_test!
      end

      response(404, 'not found') do
        example 'application/json', :example_not_found, {
          "status": 404,
          "error": 'Not Found'
        }

        let(:id) { '1' }

        run_test!
      end
    end
  end
end
