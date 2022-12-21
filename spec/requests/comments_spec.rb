require 'swagger_helper'

RSpec.describe 'comments', type: :request do
  path '/lessons/{lesson_id}/comments' do
    parameter name: 'lesson_id', in: :path, type: :string, description: 'lesson_id'
    
    get('list comments') do
      parameter name: 'page', in: :query, type: :integer, default: 1, required: false
      parameter name: 'items', in: :query, type: :integer, required: false
      parameter name: 'sort_field', in: :query, type: :string, required: false
      parameter name: 'sort_type', in: :query, type: :string, required: false
      tags 'Comments'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1 },
            body: { type: :string },
            lesson_id: { type: :integer, minimum: 1 },
            user_id: { type: :integer, minimum: 1 },
            created_at: { type: :string },
            updated_at: { type: :string }
          },
          required: %w[id body lesson_id user_id created_at updated_at]
        }
        run_test!
      end
    end

    post('create comment') do
      tags 'Comments'
      produces 'application/json'

      response(200, 'successful') do
        consumes 'application/json'
        parameter name: :new_comment, in: :body, schema: {
          type: 'object',
          properties: {
            body: { type: :string }
          },
          required: %w[body]
        }
        schema type: 'object',
               properties: {
                 id: { type: :integer, minimum: 1 },
                 body: { type: :string },
                 lesson_id: { type: :integer, minimum: 1 },
                 user_id: { type: :integer, minimum: 1 },
                 created_at: { type: :string }
               },
               required: %w[id body lesson_id user_id created_at]
        run_test!
      end

      response(400, 'bad request') do
        example 'application/json', :example_blank_body, {
          errors: [
            "Body can't be blank"
          ]
        }
        run_test!
      end
    end
  end

  path '/lessons/{lesson_id}/comments/{id}' do
    parameter name: 'lesson_id', in: :path, type: :string, description: 'lesson_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    patch('update comment') do
      tags 'Comments'
      produces 'application/json'

      response(200, 'successful') do
        consumes 'application/json'
        parameter name: :update_comment, in: :body, schema: {
          type: 'object',
          properties: {
            body: { type: :string }
          },
          required: %w[body]
        }
        schema type: 'object',
               properties: {
                 id: { type: :integer, minimum: 1 },
                 body: { type: :string },
                 lesson_id: { type: :integer, minimum: 1 },
                 user_id: { type: :integer, minimum: 1 },
                 created_at: { type: :string },
                 updated_at: { type: :string }
               },
               required: %w[id body lesson_id user_id created_at updated_at]
        run_test!
      end

      response(400, 'bad request') do
        example 'application/json', :example_blank_body, {
          errors: [
            "Body can't be blank"
          ]
        }
        run_test!
      end

      response(404, 'not found') do
        example 'application/json', :example_not_found, {
          error: 'not found'
        }
        run_test!
      end
    end

    delete('delete comment') do
      tags 'Comments'
      produces 'application/json'

      response(200, 'successful') do
        schema type: 'object',
               properties: {
                 id: { type: :integer, minimum: 1 }
               },
               required: %w[id]
        run_test!
      end

      response(401, 'unauthorized') do
        example 'application/json', :example_unauthorized, {
          error: 'unauthorized'
        }
        run_test!
      end

      response(404, 'not found') do
        example 'application/json', :example_not_found, {
          error: 'not found'
        }
        run_test!
      end
    end
  end
end
