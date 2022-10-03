require 'swagger_helper'

RSpec.describe 'categories', type: :request do
  path '/{locale}/categories' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'

    get('list categories') do
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   description: { type: :string }
                 }
               }
        run_test!
      end
    end

    post('create category') do
      response(200, 'successful') do
        example 'application/json', :example_key, {
          name: 'Web development',
          description: 'All web-developer stacks'
        }

        consumes 'application/json'
        parameter name: :category, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            description: { type: :string }
          },
          required: %w[name description]
        }
        run_test!
      end
    end
  end

  path '/{locale}/categories/new' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'

    get('new category') do
      response(200, 'successful') do
        let(:locale) { '123' }

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

  path '/{locale}/categories/{id}/edit' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'
    parameter name: 'id', in: :path, type: :string, description: 'id'
  end

  path '/{locale}/categories/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'locale', in: :path, type: :string, description: 'locale'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show category') do
      response(200, 'successful') do
        run_test!
      end

      response(404, 'not found') do
        example 'application/json', :example_key, {
          error: "Couldn't find Category with 'id'=wrong_id"
        }
        run_test!
      end
    end
    put('update category') do
      response(200, 'successful') do
        run_test!
      end
    end
  end
end
