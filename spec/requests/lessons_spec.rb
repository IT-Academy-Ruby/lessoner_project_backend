require 'swagger_helper'

RSpec.describe 'lessons', type: :request do
  path '/lessons' do
    get('list lessons') do
      tags 'Lessons'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: { '$ref' => '#/components/schemas/lesson' }

        run_test!
      end
    end

    post('create lesson') do
      tags 'Lessons'
      produces 'application/json'
      response(200, 'successful') do
        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: { '$ref' => '#/components/schemas/lesson_create' }
        schema '$ref' => '#/components/schemas/lesson_extended'

        run_test!
      end
      response(422, 'invalid request') do
        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: { '$ref' => '#/components/schemas/lesson_create' }
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
        schema '$ref' => '#/components/schemas/lesson_extended'
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
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { '1' }

        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: { '$ref' => '#/components/schemas/lesson_update' }
        schema '$ref' => '#/components/schemas/lesson_extended'
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
