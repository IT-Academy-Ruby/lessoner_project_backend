require 'swagger_helper'

RSpec.describe 'lessons', type: :request do
  path '/{locale}/lessons' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'

    get('list lessons') do
      tags 'Lessons'
      produces 'application/json'

      response(200, 'successful') do
        example 'application/json', :one_item_in_list, [{
          title: 'Ruby on Rails',
          description: 'Introduce',
          id: '1'
        }]


        schema type: :array, items: { '$ref' => '#/components/schemas/lesson' }

        let(:locale) { 'en' }
        run_test!
      end
    end

    post('create lesson') do
      tags 'Lessons'
      produces 'application/json'
      response(200, 'successful') do
        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: { '$ref' => '#/components/schemas/lesson_create' }
        example 'application/json', :example_key, {
          id: 22,
          title: 'Ruby on Rails',
          description: 'Introduce',
          video_link: 'link',
          status: 'status',
          author_id: 1,
          category_id: 1
        }

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

  path '/{locale}/lessons/{id}' do
    parameter name: 'locale', in: :path, type: :string, description: 'locale'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show lesson') do
      tags 'Lessons'
      response(200, 'successful') do
        example 'application/json', :example_key, {
          title: 'Ruby on Rails',
          description: 'Introduce',
          video_link: 'link',
          status: 'status',
          author_id: 1,
          category_id: 1
        }

        schema '$ref' => '#/components/schemas/lesson'
        let(:locale) { 'en' }
        let(:id) { '1' }

        run_test!
      end
      response(404, 'not found') do
        example 'application/json', :example_not_found, {
          "status": 404,
          "error": 'Not Found'
        }

        let(:locale) { 'en' }
        let(:id) { '1' }

        run_test!
      end
    end

    put('update lesson') do
      tags 'Lessons'
      produces 'application/json'
      response(200, 'successful') do
        let(:locale) { 'en' }
        let(:id) { '1' }
        example 'application/json', :example_key, {
          id: 22,
          title: 'Ruby on Rails',
          description: 'Introduce',
          video_link: 'link',
          status: 'status',
          author_id: 1,
          category_id: 1
        }

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
        let(:locale) { 'en' }
        let(:id) { '1' }
        run_test!
      end
    end
  end
end
