class BmrCalculationSerializer
  include JSONAPI::Serializer

  attributes :patient_id, :formula, :result, :created_at

  # Association
  belongs_to :patient, serializer: :patient
end
