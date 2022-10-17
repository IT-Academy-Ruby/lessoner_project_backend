require 'swagger_helper'

RSpec.describe 'categories', type: :request do
  path '/{locale}/categories' do
    parameter name: 'locale', in: :path, type: :string, description: 'locale'

    get('list categories') do
      tags 'Categories'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: { '$ref' => '#/components/schemas/category' }

        let(:locale) { 'en' }
        run_test!
      end
    end

    post('create category') do
      tags 'Categories'
      produces 'application/json'

      response(200, 'successful') do
        consumes 'application/json'
        parameter name: :new_category, in: :body, schema: { '$ref' => '#/components/schemas/create_category' }
        schema '$ref' => '#/components/schemas/category'

        let(:locale) { 'en' }
        run_test!
      end
      response(422, 'invalid request') do
        example 'application/json', :example_blank_name, {
          errors: {
            name: [
              "can't be blank"
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

        let(:locale) { 'en' }
        let(:id) { 1 }
        run_test!
      end
    end
  end

  path '/{locale}/categories/{id}' do
    parameter name: 'locale', in: :path, type: :string, description: 'locale'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show category') do
      tags 'Categories'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/category'

        let(:locale) { 'en' }
        let(:id) { 1 }
        run_test!
      end
    end

    put('update category') do
      tags 'Categories'
      produces 'application/json'

      response(200, 'successful') do
        consumes 'application/json'
        parameter name: :updated_category, in: :body, schema: { '$ref' => '#/components/schemas/update_category' }
        schema '$ref' => '#/components/schemas/category'

        let(:locale) { 'en' }
        let(:id) { 1 }
        run_test!
      end
    end
  end
end