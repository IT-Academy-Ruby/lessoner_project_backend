require 'swagger_helper'

RSpec.describe 'lessons', type: :request do
  path '/{locale}/lessons' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'

    get('list lessons') do
      tags 'Lessons'
      produces 'application/json'

      response(200, 'successful') do
        example 'application/json', :example_key, {
          title: 'Ruby on Rails',
          description: 'Introduce',
          id: '1'
        }


        schema type: :array, items: { '$ref' => '#/components/schemas/lesson' }

        let(:locale) { 'en' }
        run_test!
      end
    end

    post('create lesson') do
      tags 'Lessons'
      response(200, 'successful') do
        example 'application/json', :example_key, {
          title: 'Ruby on Rails',
          description: 'Introduce',
          video_link: 'link',
          status: 'status',
          author_id: 1
        }

        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: { '$ref' => '#/components/schemas/create_lesson' }

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
          vvideo_link: 'link',
          status: 'status',
          author_id: 1
        }

        schema '$ref' => '#/components/schemas/lesson'
        let(:locale) { 'en' }
        let(:id) { '1' }

        run_test!
      end
    end

    put('update lesson') do
      tags 'Lessons'
      response(200, 'successful') do
        let(:locale) { 'en' }
        let(:id) { '1' }
        example 'application/json', :example_key, {
          title: 'Ruby on Rails',
          description: 'Introduce',
          vvideo_link: 'link',
          status: 'status',
          author_id: 1,
          id: 1
        }

        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: { '$ref' => '#/components/schemas/update_lesson' }
        schema '$ref' => '#/components/schemas/lesson'
        run_test!
      end
    end

    delete('delete lesson') do
      tags 'Lessons'
      response(200, 'successful') do
        let(:locale) { 'en' }
        let(:id) { '1' }
        example 'application/json', :example_key, {
          id: 1
        }

        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: { '$ref' => '#/components/schemas/update_lesson' }
        schema '$ref' => '#/components/schemas/update_lesson'
        run_test!
      end
    end
  end
end
