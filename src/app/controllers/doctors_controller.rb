require './config/container'

class DoctorsController < ApplicationController
  before_action :validate_doctor_id, only: [:show, :update, :destroy]

  def index
    pagination_params = extract_pagination_params(params)
    search_param = { search: params[:search] }

    result = doctor_service.list(pagination_params.merge(search_param))


    render_collection(DoctorSerializer, result[:doctors], meta: { pagination: result[:pagination] })
  end

  def show
    doctor = doctor_service.show(params[:id])
    render_resource(DoctorSerializer, doctor)
  end

  def create
    doctor = doctor_service.create(doctor_params)
    render_resource(DoctorSerializer, doctor, status: :created)
  end

  def update
    doctor = doctor_service.update(params[:id], doctor_params)
    render_resource(DoctorSerializer, doctor)
  end

  def destroy
    doctor_service.destroy(params[:id])

    render json: {
      success: true
    }
  end

  private
  def doctor_service
    ApplicationContainer.resolve('doctor_service')
  end

  private
  def response_formatter
    ApplicationContainer.resolve('response_formatter')
  end

  private
  def validate_doctor_id
    validate_uuid_param(params[:id])
  end

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :middle_name).to_h
  end
end
