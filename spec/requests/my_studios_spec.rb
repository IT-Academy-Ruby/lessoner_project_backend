require 'swagger_helper'

RSpec.describe 'my_studios', type: :request do
  path '/my_studio/lessons' do
    get('list my_studios') do
      tags 'my_studios'
      produces 'application/json'

      response(200, 'ok') do
        schema type: :array, items: { '$ref' => '#/components/schemas/lesson' }

        run_test!
      end
    end
  end
end
