require 'swagger_helper'

RSpec.describe 'lessons', type: :request do
  path '/lessons' do
    get('list lessons') do
      parameter name: 'page', in: :query, type: :integer, default: 1, required: false
      parameter name: 'items', in: :query, type: :integer, required: false
      parameter name: 'status', in: :query, schema: { type: :string, enum: Lesson::STATUSES }
      parameter name: 'category_id', in: :query, type: :integer, required: false
      parameter name: 'sort_field', in: :query, type: :string, required: false
      parameter name: 'sort_type', in: :query, type: :string, required: false
      tags 'Lessons'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object, properties: {
                                records: { type: :array, items: { '$ref' => '#/components/schemas/lesson' } },
                                pagy_metadata: { '$ref' => '#/components/schemas/pagy_metadata' }
                              },
               required: %w[records pagy_metadata]

        run_test!
      end
    end

    post('create lesson') do
      tags 'Lessons'
      consumes 'application/json'
      produces 'application/json'
      parameter title: :lesson, in: :body, schema: { '$ref' => '#/components/schemas/lesson_create' }

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/lesson_show'

        run_test!
      end
      response(422, 'invalid request') do
        example 'application/json', :example_blank_author, {
          errors: {
            author: [
              'must exist'
            ]
          }
        }
        example 'application/json', :example_blank_description, {
          errors: {
            description: [
              "can't be blank"
            ]
          }
        }
        schema '$ref' => '#/components/schemas/errors_object'

        run_test!
      end
    end
  end

  path '/lessons/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show lesson') do
      tags 'Lessons'
      produces 'application/json'
      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/lesson_show'
        let(:id) { '1' }

        run_test!
      end
      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/error_not_found'

        let(:id) { '1' }

        run_test!
      end
    end

    put('update lesson') do
      tags 'Lessons'
      consumes 'application/json'
      produces 'application/json'
      parameter title: :lesson, in: :body, schema: { '$ref' => '#/components/schemas/lesson_update' }

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/lesson_show'

        let(:id) { '1' }
        run_test!
      end
    end

    delete('delete lesson') do
      tags 'Lessons'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/lesson_delete'
        let(:id) { '1' }

        run_test!
      end
      response(404, 'not found') do
        schema '$ref' => '#/components/schemas/error_not_found'
        let(:id) { '1' }

        run_test!
      end
    end
  end
end
