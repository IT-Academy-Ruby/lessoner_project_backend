require 'swagger_helper'

RSpec.describe 'sign_up', type: :request do
  path '/sign_up' do
    post('create sign_up') do
      tags 'Sign_up'
      produces 'application/json'
      parameter name: :signup, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          phone: { type: :string },
          gender: { type: :string, enum: %w[male female other] },
          email: { type: :string },
          birthday: { type: :string, format: :date },
          password: { type: :string }
        },
        required: %w[name gender email password]
      }
      response(201, 'created') do
        consumes 'application/json'
        schema type: :object,
               properties: {
                 id: { type: :integer, minimum: 1 },
                 name: { type: :string },
                 phone: { type: :string },
                 gender: { type: :string, enum: %w[male female other] },
                 email: { type: :string },
                 birthday: { type: :string }
               },
               required: %w[id name gender email]
        run_test!
      end
      response(400, 'bad request') do
        example 'application/json', :example_already_exists, {
          errors: [
            'Email has already been taken',
            'Name has already been taken'
          ]
        }
        run_test!
      end
    end
  end
end
