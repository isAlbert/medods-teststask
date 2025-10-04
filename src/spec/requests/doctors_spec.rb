require 'swagger_helper'

RSpec.describe 'Doctors API', type: :request do
  path '/doctors' do
    get 'Список врачей с ФИО' do
      tags 'Doctors'
      description 'Получить список всех врачей с поддержкой ФИО'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, description: 'Номер страницы', required: false, example: 1
      parameter name: :per_page, in: :query, type: :integer, description: 'Количество на странице', required: false, example: 20
      parameter name: :search, in: :query, type: :string, description: 'Поиск по ФИО врача', required: false, example: 'Петрова'

      response '200', 'Список врачей получен успешно' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Doctor' }
                 },
                 meta: {
                   type: :object,
                   properties: {
                     pagination: { '$ref' => '#/components/schemas/PaginationMeta' }
                   }
                 }
               }
        run_test!
      end
    end

    post 'Создать врача с ФИО' do
      tags 'Doctors'
      description 'Создать нового врача с поддержкой ФИО'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :doctor_data, in: :body, schema: { '$ref' => '#/components/schemas/DoctorCreateRequest' }

      response '201', 'Врач создан успешно' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: { '$ref' => '#/components/schemas/Doctor' }
               }
        run_test!
      end
    end
  end

  path '/doctors/{id}' do
    parameter name: :id, in: :path, type: :string, format: :uuid, description: 'Doctor UUID'

    get 'Получить врача' do
      tags 'Doctors'
      produces 'application/json'

      response '200', 'Врач найден' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: { '$ref' => '#/components/schemas/Doctor' }
               }
        run_test!
      end
    end

    put 'Обновить врача' do
      tags 'Doctors'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :doctor_data, in: :body, schema: { '$ref' => '#/components/schemas/DoctorCreateRequest' }

      response '200', 'Врач обновлен успешно' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: { '$ref' => '#/components/schemas/Doctor' }
               }
        run_test!
      end
    end

    delete 'Удалить врача' do
      tags 'Doctors'
      produces 'application/json'

      response '200', 'Врач удален успешно' do
        run_test!
      end
    end
  end
end
