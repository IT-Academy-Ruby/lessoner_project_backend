# frozen_string_literal: true

require 'rails_helper'

SWAGGER_DOCS = {
  'v1/swagger.yaml' => {
    openapi: '3.0.1',
    info: {
      title: 'API V1',
      version: 'v1'
    },
    paths: {},
    servers: [
      {
        url: 'http://{herokuapp}',
        variables: {
          herokuapp: {
            default: 'lessoner.herokuapp.com/'
          }
        }
      },
      {
        url: 'http://{localHost1}',
        variables: {
          localHost1: {
            default: 'localhost:3000/'
          }
        }
      },
      {
        url: 'http://{localHost2}',
        variables: {
          localHost2: {
            default: '127.0.0.1:3000/'
          }
        }
      }
    ],
    components: {
      schemas: {
        errors_object: {
          type: 'object',
          properties: {
            errors: { '$ref' => '#/components/schemas/errors_map' }
          }
        },
        errors_map: {
          type: 'object',
          additionalProperties: {
            type: 'array',
            items: { type: 'string' }
          }
        },
        category: {
          type: 'object',
          properties: {
            id: { type: :integer, minimum: 1 },
            name: { type: :string },
            description: { type: :string },
            status: { type: :string, enum: Category::STATUSES }
          },
          required: %w[id name description status]
        },
        create_category: {
          type: 'object',
          properties: {
            name: { type: :string },
            description: { type: :string },
            status: { type: :string, enum: Category::STATUSES }
          },
          required: %w[name description]
        },
        update_category: {
          type: 'object',
          minProperties: 1,
          properties: {
            name: { type: :string },
            description: { type: :string },
            status: { type: :string, enum: Category::STATUSES }
          }
        },
        lesson: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1 },
            title: { type: :string },
            description: { type: :string }
          },
          required: %w[id title description]
        },
        create_lesson: {
          type: :object,
          properties: {
            title: { type: :string },
            description: { type: :string },
            video_link: { type: :string },
            status: { type: :integer, enum: Category::STATUSES },
            author_id: { type: :integer, minimum: 1 },
            category_id: { type: :integer, minimum: 1 }
          },
          required: %w[title description video_link author_id]
        },
        lesson_extended: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1 },
            title: { type: :string },
            description: { type: :string },
            video_link: { type: :string },
            status: { type: :integer, enum: Category::STATUSES },
            author_id: { type: :integer, minimum: 1 },
            category_id: { type: :integer, minimum: 1 }
          },
          required: %w[title description status video_link author_id]
        },
        update_lesson: {
          type: :object,
          minProperties: 1,
          properties: {
            title: { type: :string },
            description: { type: :string },
            video_link: { type: :string },
            status: { type: :integer, enum: Lesson::STATUSES },
            author_id: { type: :integer, minimum: 1 },
            category_id: { type: :integer, minimum: 1 }
          }

        },
        delete_lesson: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1 }
          },
          required: %w[id]
        }
      }
    }
  }
}.freeze

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = SWAGGER_DOCS

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
