class DoctorSerializer
  include JSONAPI::Serializer

  attributes :first_name, :last_name, :middle_name, :created_at, :updated_at


  #has_many :patients, serializer: :patient
end
