require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/users' do
    get('list users') do
      parameter name: 'page', in: :query, type: :integer, default: 1, required: false
      parameter name: 'items', in: :query, type: :integer, required: false
      parameter name: 'sort_field', in: :query, type: :string, required: false
      parameter name: 'sort_type', in: :query, type: :string, required: false
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

    put('update user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        oneOf: [
          { '$ref' => '#/components/schemas/update_user' },
          {
            type: :object,
            properties: {
              phone: { type: :string, example: '+375297774455' }
            }
          },
          {
            type: :object,
            properties: {
              email: { type: :string, example: 'nagibator2000@gmail.com' }
            }
          },
          {
            type: :object,
            properties: {
              password: { type: :string, example: '9p0i5z6de67c4' },
              current_password: { type: :string, example: '1234567890' }
            },
            required: %w[password current_password]
          }
        ]
      }

      response(200, 'ok') do
        example 'application/json', :updated, {
          id: 1,
          email: 'abc@gmail.com',
          name: 'User name',
          description: 'User description',
          avatar_url: 'https://lessoner.s3.amazonaws.com/image-url',
          phone: '+375291234567',
          verified: false,
          gender: 'female',
          birthday: '2000-01-01',
          created_at: '2022-12-01 14:11:33 +0300'
        }

        example 'application/json', :email_sent, {
          deliver: 'sent'
        }

        run_test!
      end

      response(403, 'forbidden') do
        example 'application/json', :password_not_match, {
          error: 'current password does not match'
        }

        run_test!
      end

      response(422, 'unprocessable entity') do
        example 'application/json', :name_too_short, {
          errors: {
            name: [
              'is too short (minimum is 3 characters)'
            ]
          }
        }

        example 'application/json', :email_exists, {
          error: 'email already exists'
        }

        run_test!
      end
    end
  end

  path '/users/update_email?token={token}' do
    parameter name: 'token', in: :path, type: :string, description: 'token'

    get('update email') do
      tags 'Users'
      produces 'application/json'

      response(200, 'ok') do
        example 'application/json', :updated, {
          user: 'email has been changed'
        }

        run_test!
      end

      response(404, 'not found') do
        example 'application/json', :user_not_found, {
          error: 'Not found'
        }

        run_test!
      end
    end
  end

  path '/verify' do
    post('verify phone') do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          verification_code: { type: :string, example: '54957' }
        }
      }

      response(200, 'ok') do
        example 'application/json', :verified, {
          verified: true
        }

        run_test!
      end

      response(422, 'unprocessable entity') do
        example 'application/json', :invalid_code, {
          error: 'the code is invalid'
        }

        run_test!
      end
    end
  end
end
