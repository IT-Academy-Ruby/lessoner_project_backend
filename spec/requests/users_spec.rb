require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/{locale}/users/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show user') do
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
        let(:locale) { 'en' }
        let(:id) { '3' }

        run_test!
      end
    end
  end
end
