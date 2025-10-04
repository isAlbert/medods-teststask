require 'swagger_helper'

RSpec.describe 'Calculations API', type: :request do
  path '/bmi' do
    post 'Рассчитать BMI' do
      tags 'Calculations'
      description 'Рассчитать индекс массы тела (BMI)'
      produces 'application/json'

      parameter name: :height, in: :query, type: :number, description: 'Height in meters', required: true
      parameter name: :weight, in: :query, type: :number, description: 'Weight in kilograms', required: true

      response '200', 'BMI calculated successfully' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: {
                   type: :object,
                   properties: {
                     bmi: { type: :number, format: :float, description: 'Calculated BMI value' },
                     category: { type: :string, enum: ['Underweight', 'Normal', 'Overweight', 'Obese'], description: 'BMI category' },
                   }
                 }
               }
        run_test!
      end
    end
  end
end
