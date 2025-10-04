class DoctorContract < Dry::Validation::Contract
  params do
    required(:first_name).filled(:string)
    required(:last_name).filled(:string)
    optional(:middle_name).maybe(:string)
  end

  # Валидация имени
  rule(:first_name) do
    ValidationMacros.validate_first_name(value, key)
  end

  # Валидация фамилии
  rule(:last_name) do
    ValidationMacros.validate_last_name(value, key)
  end

  # Валидация отчества (опционально)
  rule(:middle_name) do
    ValidationMacros.validate_middle_name(value, key) if value.present?
  end


  # Проверка на дубликаты по ФИО
  rule(:first_name, :last_name, :middle_name) do
    next unless values[:first_name].present? && values[:last_name].present?

    # Проверяем существование врача с таким же ФИО
    existing_doctor = Doctor.where(
      first_name: values[:first_name].strip,
      last_name: values[:last_name].strip,
      middle_name: values[:middle_name]&.strip
    ).first

    if existing_doctor.present?
      key(:last_name).failure('врач с таким ФИО уже существует')
    end
  rescue => e
    Rails.logger&.error "Doctor uniqueness validation error: #{e.message}"
  end
end
