require_relative '../app/services/patient_service'
require_relative '../app/services/doctor_service'
require_relative '../app/services/bmr_service'
require_relative '../app/services/bmi_service'

require 'dry-container'
require 'dry-auto_inject'

class ApplicationContainer
  extend Dry::Container::Mixin

  register('patient_service') { PatientService.new }
  register('doctor_service') { DoctorService.new }
  register('bmr_service') { BmrService.new }
  register('bmi_service') { BmiService.new }
end

Import = Dry::AutoInject(ApplicationContainer)

Rails.logger.info "ApplicationContainer initialized with #{ApplicationContainer._container.keys.size} services" if defined?(Rails.logger)
