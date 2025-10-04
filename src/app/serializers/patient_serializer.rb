class PatientSerializer
  include JSONAPI::Serializer

  attributes :first_name, :last_name, :middle_name, :birthday, :gender, :height, :weight, :created_at, :updated_at

  has_many :doctors, serializer: :doctor
  has_many :bmr_calculations, serializer: :bmr_calculation

end
