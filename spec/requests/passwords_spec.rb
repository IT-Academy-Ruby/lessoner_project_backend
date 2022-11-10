require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  path '/password/forgot' do
    post('send reset link to email') do
      tags 'Sign_up'
      produces 'application/json'
      parameter name: :signup, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string }
        },
        required: %w[email]
      }
    end
    response(200, 'successful') do
      schema type: :object,
             properties: {
               alert: { type: :string,
                        example: "We've sent a link to restore access to your account to the address email" }
             },
             required: %w[alert]
      run_test!
    end
    response(404, 'not found') do
      example 'application/json', :not_found, {
        "error": 'User is not found. Please enter a valid email address'
      }
      run_test!
    end
  end

  path '/password/reset' do
    post('reset password') do
      tags 'Sign_up'
      produces 'application/json'
      parameter name: :signup, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          token: { type: :string },
          password: { type: :string }
        },
        required: %w[email token password]
      }
    end
    response(200, 'successful') do
      schema type: :object,
             properties: {
               status: { type: :string,
                         example: 'ok' }
             },
             required: %w[status]
      run_test!
    end
    response(404, 'not found') do
      example 'application/json', :not_found, {
        "error": 'Link not valid or expired. Try generating a new link.'
      }
      run_test!
    end
    response(422, 'unprocessable entity') do
      example 'application/json', :unprocessable_entity, {
        "error": 'User errors full messages'
      }
      run_test!
    end
  end
end
