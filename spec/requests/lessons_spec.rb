require 'swagger_helper'

RSpec.describe 'lessons', type: :request do

  path '(/{locale)}/lessons' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'

    get('list lessons') do
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: {type: :integer},
                    title: {type: :string },
                    description: {type: :string}
                  }
               }
        run_test!
      end
    end

    post('create lesson') do
      response(200, 'successful') do
        example 'application/json', :example_key, {
          title: 'Ruby on Rails ',
          description: 'Introduce'
        }

        consumes 'application/json'
        parameter title: :lesson, in: :body, schema: {
          type: :object,
          properties: {
            title: { type: :string },
            description: { type: :string }
          },
          required: %w[title description]
        }
        run_test!
      end
    end
  end



  path '(/{locale)}/lessons/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show lesson') do
      response(200, 'successful') do
        let(:locale) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('update lesson') do
      response(200, 'successful') do
        let(:locale) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update lesson') do
      response(200, 'successful') do
        let(:locale) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete lesson') do
      response(200, 'successful') do
        let(:locale) { '123' }
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
