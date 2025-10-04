# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ],
      components: {
        schemas: {
          Patient: {
            type: :object,
            properties: {
              id: { type: :string, format: :uuid, description: 'Unique patient identifier' },
              first_name: { type: :string, minLength: 2, maxLength: 50, description: 'Имя пациента', example: 'Иван' },
              last_name: { type: :string, minLength: 2, maxLength: 50, description: 'Фамилия пациента', example: 'Петров' },
              middle_name: { type: :string, maxLength: 50, description: 'Отчество пациента (опционально)', example: 'Сергеевич', nullable: true },
              birthday: { type: :string, format: :date, description: 'Дата рождения', example: '1990-01-15' },
              gender: { type: :string, enum: ['male', 'female'], description: 'Пол', example: 'male' },
              height: { type: :integer, minimum: 30, maximum: 300, description: 'Рост в сантиметрах', example: 180 },
              weight: { type: :number, format: :float, minimum: 10, maximum: 500, description: 'Вес в килограммах', example: 75.5 },
              created_at: { type: :string, format: :datetime, readOnly: true, example: '2025-09-30T13:31:13.805Z'},
              updated_at: { type: :string, format: :datetime, readOnly: true, example: '2025-09-30T13:31:13.805Z'}
            },
            required: [:first_name, :last_name, :birthday, :gender, :height, :weight]
          },
          Doctor: {
            type: :object,
            properties: {
              id: { type: :string, format: :uuid, description: 'Unique doctor identifier' },
              first_name: { type: :string, minLength: 2, maxLength: 50, description: 'Имя врача', example: 'Анна' },
              last_name: { type: :string, minLength: 2, maxLength: 50, description: 'Фамилия врача', example: 'Петрова' },
              middle_name: { type: :string, maxLength: 50, description: 'Отчество врача (опционально)', example: 'Владимировна', nullable: true },
              created_at: { type: :string, format: :datetime, readOnly: true, example: '2025-09-30T13:31:13.805Z' },
              updated_at: { type: :string, format: :datetime, readOnly: true, example: '2025-09-30T13:31:13.805Z' }
            },
            required: [:first_name, :last_name]
          },
          BmrCalculation: {
            type: :object,
            properties: {
              id: { type: :string, format: :uuid, description: 'Unique calculation identifier' },
              patient_id: { type: :string, format: :uuid, description: 'Patient UUID' },
              formula: { type: :string, enum: ['mifflin', 'harris'], description: 'BMR calculation formula' },
              result: { type: :number, format: :float, minimum: 500, maximum: 5000, description: 'BMR result in kcal/day' },
              created_at: { type: :string, format: :datetime, readOnly: true, example: '2025-09-30T13:31:13.805Z' }
            },
            required: [:patient_id, :formula, :result]
          },
          PaginationMeta: {
            type: :object,
            properties: {
              current_page: { type: :integer, description: 'Current page number', example: 1 },
              per_page: { type: :integer, description: 'Items per page', example: 20 },
              total_count: { type: :integer, description: 'Total number of items', example: 47 },
              total_pages: { type: :integer, description: 'Total number of pages', example: 3 },
              has_next_page: { type: :boolean, description: 'Whether next page exists', example: true },
              has_previous_page: { type: :boolean, description: 'Whether previous page exists', example: false },
              next_page: { type: :integer, nullable: true, description: 'Next page number', example: 2 },
              previous_page: { type: :integer, nullable: true, description: 'Previous page number', example: nil }
            }
          },
          PatientCreateRequest: {
            type: :object,
            properties: {
              patient: {
                type: :object,
                properties: {
                  first_name: { type: :string, minLength: 2, maxLength: 50, description: 'Имя', example: 'Иван' },
                  last_name: { type: :string, minLength: 2, maxLength: 50, description: 'Фамилия', example: 'Петров' },
                  middle_name: { type: :string, maxLength: 50, description: 'Отчество (опционально)', example: 'Сергеевич' },
                  birthday: { type: :string, format: :date, description: 'Дата рождения', example: '1990-01-15' },
                  gender: { type: :string, enum: ['male', 'female'], description: 'Пол', example: 'male' },
                  height: { type: :integer, minimum: 30, maximum: 300, description: 'Рост в см', example: 180 },
                  weight: { type: :number, minimum: 10, maximum: 500, description: 'Вес в кг', example: 75.5 },
                  doctor_ids: { type: :array, items: { type: :string, format: :uuid }, description: 'UUIDs врачей' }
                },
                required: [:first_name, :last_name, :birthday, :gender, :height, :weight]
              }
            },
            required: [:patient]
          },
          DoctorCreateRequest: {
            type: :object,
            properties: {
              doctor: {
                type: :object,
                properties: {
                  first_name: { type: :string, minLength: 2, maxLength: 50, description: 'Имя', example: 'Анна' },
                  last_name: { type: :string, minLength: 2, maxLength: 50, description: 'Фамилия', example: 'Петрова' },
                  middle_name: { type: :string, maxLength: 50, description: 'Отчество (опционально)', example: 'Владимировна' }
                },
                required: [:first_name, :last_name]
              }
            },
            required: [:doctor]
          },
          SuccessResponse: {
            type: :object,
            properties: {
              success: { type: :boolean, example: true },
              data: { type: :object, description: 'Response data' },
              meta: {
                type: :object,
                properties: {
                  pagination: { '$ref' => '#/components/schemas/PaginationMeta' }
                },
                description: 'Response metadata (pagination only)'
              }
            },
            required: [:success]
          },
          ErrorResponse: {
            type: :object,
            properties: {
              success: { type: :boolean, example: false },
              error: { type: :string, description: 'Error message', example: 'Фамилия должна содержать минимум 2 символа' },
              details: {
                type: :array,
                items: { type: :string },
                description: 'Detailed error messages',
                example: ['first_name: должно содержать минимум 2 символа', 'last_name: не может быть пустым']
              }
            },
            required: [:success, :error]
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
