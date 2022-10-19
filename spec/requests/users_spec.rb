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
  path '/{locale}/check_email?email={email}' do
    parameter name: 'locale', in: :path, type: :string, description: 'locale'
    parameter name: 'email', in: :path, type: :string, description: 'email'

    get('check email') do
      produces 'application/json'
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 email_exists: { type: :boolean, example: 'true' }
               },
               required: %w[email_exists]
        run_test!
      end
    end
  end
  path '/{locale}/check_username?name={username}' do
    parameter name: 'locale', in: :path, type: :string, description: 'locale'
    parameter name: 'username', in: :path, type: :string, description: 'username'

    get('check username') do
      tags 'Users'
      produces 'application/json'
      response(200, 'successful') do
        schema type: :object,
               properties: {
                 username_exists: { type: :boolean, example: 'true' }
               },
               required: %w[username_exists]
        run_test!
      end
    end
  end
end
