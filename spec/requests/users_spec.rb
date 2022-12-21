require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/users/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show user') do
      tags 'Users'
      produces 'application/json'
      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/show_user'
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

    put('update user (name, description, gender, birthday)') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: { '$ref' => '#/components/schemas/update_user' }

      response(200, 'ok') do
        schema '$ref' => '#/components/schemas/show_user'

        run_test!
      end

      response(422, 'unprocessable entity') do
        example 'application/json', :example_name_too_short, {
          errors: {
            name: [
              'is too short (minimum is 3 characters)'
            ]
          }
        }

        run_test!
      end
    end
  end
end
