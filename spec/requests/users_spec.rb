require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/users/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show user') do
      tags 'Users'
      produces 'application/json'
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 id: { type: :integer, minimum: 1 },
                 name: { type: :string },
                 description: { type: :string },
                 email: { type: :string },
                 avatar_url: { type: :string }
               },
               required: %w[id name description email avatar_url]
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
