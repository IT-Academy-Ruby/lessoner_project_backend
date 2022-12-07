require 'rails_helper'

RSpec.describe 'Public::Users', type: :request do
  path '/check_email?email={email}' do
    parameter name: 'email', in: :path, type: :string, description: 'email'

    get('check email') do
      tags 'Users public'
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
  path '/check_username?name={username}' do
    parameter name: 'username', in: :path, type: :string, description: 'username'

    get('check username') do
      tags 'Users public'
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
