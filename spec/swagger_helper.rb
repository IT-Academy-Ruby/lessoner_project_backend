# frozen_string_literal: true

require 'rails_helper'

SWAGGER_DOCS = {
  'v1/swagger.yaml' => {
    openapi: '3.0.1',
    info: {
      title: 'Lessoner API',
      version: 'v1'
    },
    paths: {},
    servers: [
      {
        url: 'https://{lessonerTest}',
        variables: {
          lessonerTest: {
            default: 'qa-test-pfm3.onrender.com/'
          }
        }
      },
      {
        url: 'https://{lessonerProd}',
        variables: {
          lessonerProd: {
            default: 'lessoner-project-2w3h.onrender.com/'
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
        error_not_found: {
          type: 'object',
          properties: {
            status: { type: :integer, enum: %i[404], example: 404 },
            error: { type: :string, example: 'Not found' }
          }
        },
        category: {
          type: 'object',
          properties: {
            id: { type: :integer, minimum: 1 },
            name: { type: :string },
            description: { type: :string },
            status: { type: :string, enum: Category::STATUSES },
            image_url: { type: :string, example: 'https://lessoner.s3.amazonaws.com/image-url' },
            created_at: { type: :string, example: '2022-12-01 14:11:33 +0300' }
          },
          required: %w[id name description status image_url created_at]
        },
        show_category: {
          type: 'object',
          properties: {
            id: { type: :integer, minimum: 1 },
            name: { type: :string },
            description: { type: :string },
            status: { type: :string, enum: Category::STATUSES },
            image_url: { type: :string, example: 'https://lessoner.s3.amazonaws.com/image-url' },
            created_at: { type: :string, example: '2022-12-01 14:11:33 +0300' },
            amount_lessons: { type: :integer, example: 0 }
          },
          required: %w[id name description status image_url created_at amount_lessons]
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
            status: { type: :string, enum: Category::STATUSES, example: 'archived' }
          }
        },
        lesson: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1 },
            title: { type: :string, example: 'Lesson name' },
            description: { type: :string, example: 'Lesson description' },
            video_link: { type: :string, example: 'http://video.com/my-video' },
            status: { type: :string, enum: Lesson::STATUSES, example: 'active' },
            author_id: { type: :integer, minimum: 1 },
            category_id: { type: :integer, minimum: 1 },
            created_at: { type: :string, example: '2022-12-01 14:11:33 +0300' },
            views_count: { type: :integer, example: 12 }
          },
          required: %w[id title description status video_link author_id category_id created_at]
        },
        lesson_create: {
          type: :object,
          properties: {
            title: { type: :string, example: 'Lesson name' },
            description: { type: :string, example: 'Lesson description' },
            video_link: { type: :string, example: 'http://video.com/my-video' },
            status: { type: :string, enum: Lesson::STATUSES, example: 'active' },
            author_id: { type: :integer, minimum: 1 },
            category_id: { type: :integer, minimum: 1 }
          },
          required: %w[title description video_link author_id category_id]
        },
        lesson_update: {
          type: :object,
          minProperties: 1,
          properties: {
            title: { type: :string, example: 'Lesson name' },
            description: { type: :string, example: 'Lesson description' },
            video_link: { type: :string, example: 'http://video.com/my-video' },
            status: { type: :string, enum: Lesson::STATUSES, example: 'active' },
            author_id: { type: :integer, minimum: 1 },
            category_id: { type: :integer, minimum: 1 }
          }
        },
        lesson_delete: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1, example: 22 }
          },
          required: %w[id]
        },
        show_user: {
          type: :object,
          properties: {
            id: { type: :integer, minimum: 1 },
            name: { type: :string, example: 'User name' },
            description: { type: :string, example: 'User description' },
            email: { type: :string, example: 'user@gmail.com' },
            avatar_url: { type: :string, example: 'https://lessoner.s3.amazonaws.com/image-url' },
            phone: { type: :string, example: '+375291234567' },
            gender: { type: :string, enum: %i[male female other] },
            birthday: { type: :string, example: '2000-01-01' },
            created_at: { type: :string, example: '2022-12-01 14:11:33 +0300' }
          },
          required: %w[id name description email avatar_url phone gender birthday created_at]
        },
        update_user: {
          type: :object,
          minProperties: 1,
          properties: {
            name: { type: :string, example: 'User name' },
            description: { type: :string, example: 'User description' },
            gender: { type: :string, enum: %i[male female other] },
            birthday: { type: :string, example: '2000-01-01' }
          }
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
