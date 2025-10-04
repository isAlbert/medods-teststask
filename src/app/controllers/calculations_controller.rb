require './config/container'

class CalculationsController < ApplicationController

  def bmi
    height = params[:height]
    weight = params[:weight]

    if height.blank? || weight.blank?

      render json: {
        success: false,
        error: "Параметры height и weight обязательны"
      }, status: :bad_request
      return
    end

    result = bmi_service.calculate(height, weight)

    render json: {
      success: true,
      data: result.except(:result)
    }
  end

  private
  def bmi_service
    ApplicationContainer.resolve('bmi_service')
  end
end
