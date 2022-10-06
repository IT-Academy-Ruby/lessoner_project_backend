require 'swagger_helper'

RSpec.describe 'lessons', type: :request do
  path '/{locale}/lessons' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'

    get('list lessons') do
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer, minimum: 1 },
                   title: { type: :string },
                   description: { type: :string }
                 },
                 required: %w[id title description]
               }
               let(:locale) { 'en' }
        run_test!
      end
    end

    post('create lesson') do
      response(200, 'successful') do
        example 'application/json', :example_key, {
          title: 'Ruby on Rails',
          description: 'Introduce',
          video_link: 'link',
          status: 'status',
          author_id: 1
        }

        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            description: { type: :string },
            video_link: { type: :string },
            status: { type: :string },
            author_id: { type: :integer, minimum: 1 }
          },
          required: %w[title description status video_link author_id]
        }
        run_test!
      end
    end
  end

  path '/{locale}/lessons/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show lesson') do
      response(200, 'successful') do
        let(:locale) { 'en' }
        let(:id) { '1' }
        example 'application/json', :example_key, {
          title: 'Ruby on Rails',
          description: 'Introduce',
          vvideo_link: 'link',
          status: 'status',
          author_id: 1
        }

        schema type: :object,
          properties: {
            id: { type: :integer, minimum: 1 },
            title: { type: :string },
            description: { type: :string },
            video_link: { type: :string },
            status: { type: :string },
            author_id: { type: :integer, minimum: 1 }
          },
          required: %w[title description status video_link author_id]


        run_test!
      end
    end


    put('update lesson') do
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
        parameter title: :lesson, in: :body, schema: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1 },
            title: { type: :string },
            description: { type: :string },
            video_link: { type: :string },
            status: { type: :string },
            author_id: { type: :integer, minimum: 1 }
          },
          required: %w[title description status video_link author_id]
        }

        run_test!
      end
    end

    delete('delete lesson') do
      response(200, 'successful') do
        let(:locale) { 'en' }
        let(:id) { '1' }
        example 'application/json', :example_key, {
         id: 1
        }

        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1 }
          }
        }

        run_test!
      end
    end
  end
end
