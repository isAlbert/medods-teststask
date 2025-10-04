require './config/container'

class PatientsController < ApplicationController
  before_action :validate_patient_id, only: [:show, :update, :destroy, :bmr, :bmr_history]


  def index
    pagination_params = extract_pagination_params(params)
    filter_params = extract_filter_params(params)

    result = patient_service.list(pagination_params.merge(filter_params))

    render_collection(DoctorSerializer, result[:doctors], meta: { pagination: result[:pagination] })
  end

  def show
    patient = patient_service.show(params[:id])
    render_resource(PatientSerializer, patient)
  end

  def create
    patient = patient_service.create(patient_params)
    render_resource(PatientSerializer, patient, status: :created)
  end

  def update
    patient = patient_service.update(params[:id], patient_params)

    render_resource(PatientSerializer, patient)
  end

  def destroy
    patient_service.destroy(params[:id])

    render json: {
      success: true
    }
  end

  def bmr
    formula = params[:formula].present? ? params[:formula].to_s.strip : nil
    calculation = bmr_service.calculate_for_patient(params[:id], formula)

    render_resource(BmrCalculationSerializer, calculation, status: :created)
  end

  def bmr_history
    pagination_params = extract_pagination_params(params)
    result = patient_service.bmr_history(params[:id], pagination_params)

    meta = { pagination: result[:pagination] } if result[:pagination]

    render_collection(BmrCalculationSerializer, result[:calculations], meta: meta)

  end

  private

  def patient_service
    ApplicationContainer.resolve('patient_service')
  end

  def response_formatter
    ApplicationContainer.resolve('response_formatter')
  end

  def bmr_service
    ApplicationContainer.resolve('bmr_service')
  end

  def validate_patient_id
    validate_uuid_param(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :middle_name, :birthday, :gender, :height, :weight, doctor_ids: []).to_h
  end
end
