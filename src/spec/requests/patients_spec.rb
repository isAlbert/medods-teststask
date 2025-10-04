require 'swagger_helper'

RSpec.describe 'Patients API', type: :request do
  path '/patients' do
    get 'Список пациентов с ФИО' do
      tags 'Patients'
      description 'Получить список всех пациентов с пагинацией и фильтрацией по ФИО'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, description: 'Номер страницы (по умолчанию: 1)', required: false, example: 1
      parameter name: :per_page, in: :query, type: :integer, description: 'Количество на странице (макс: 100)', required: false, example: 20
      parameter name: :search, in: :query, type: :string, description: 'Поиск по ФИО пациента', required: false, example: 'Петров'
      parameter name: :gender, in: :query, type: :string, enum: ['male', 'female'], description: 'Фильтр по полу', required: false

      response '200', 'Список пациентов получен успешно' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Patient' }
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

    post 'Создать пациента с ФИО' do
      tags 'Patients'
      description 'Создать нового пациента с поддержкой ФИО'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :patient_data, in: :body, schema: { '$ref' => '#/components/schemas/PatientCreateRequest' }

      response '201', 'Пациент создан успешно' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: { '$ref' => '#/components/schemas/Patient' }
               }

        run_test!
      end
    end
  end

  path '/patients/{id}' do
    parameter name: :id, in: :path, type: :string, format: :uuid, description: 'Patient UUID'

    get 'Получить пациента' do
      tags 'Patients'
      produces 'application/json'

      response '200', 'Пациент найден' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: { '$ref' => '#/components/schemas/Patient' }
               }
        run_test!
      end
    end

    put 'Обновить пациента' do
      tags 'Patients'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :patient_data, in: :body, schema: { '$ref' => '#/components/schemas/PatientCreateRequest' }

      response '200', 'Пациент обновлен успешно' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: { '$ref' => '#/components/schemas/Patient' }
               }
        run_test!
      end
    end

    delete 'Удалить пациента' do
      tags 'Patients'
      produces 'application/json'

      response '200', 'Пациент удален успешно' do
        run_test!
      end
    end
  end

  path '/patients/{id}/bmr' do
    parameter name: :id, in: :path, type: :string, format: :uuid, description: 'Patient UUID'

    post 'Рассчитать BMR' do
      tags 'Patients'
      description 'Рассчитать BMR (базовый метаболизм) для пациента'
      produces 'application/json'

      parameter name: :formula, in: :query, type: :string, enum: ['mifflin', 'harris'], description: 'Формула расчета BMR', required: false

      response '201', 'BMR рассчитан успешно' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: { '$ref' => '#/components/schemas/BmrCalculation' },
                 meta: {
                   type: :object,
                   properties: {
                     formula_used: { type: :string, example: 'mifflin' },
                     calculation_date: { type: :string, format: :datetime },
                     patient_name: { type: :string, example: 'Петров Иван С.', description: 'ФИО пациента' }
                   }
                 }
               }
        run_test!
      end
    end
  end

  path '/patients/{id}/bmr_history' do
    parameter name: :id, in: :path, type: :string, format: :uuid, description: 'Patient UUID'

    get 'История BMR' do
      tags 'Patients'
      description 'Получить историю BMR расчетов пациента'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, description: 'Номер страницы', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'Количество на странице', required: false

      response '200', 'История BMR получена успешно' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/BmrCalculation' }
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
  end
end
