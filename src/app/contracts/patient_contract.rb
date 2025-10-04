class PatientContract < Dry::Validation::Contract
  params do
    required(:first_name).filled(:string)
    required(:last_name).filled(:string)
    optional(:middle_name).maybe(:string)
    required(:birthday).filled(:date)
    required(:gender).filled(:string)
    required(:height).filled(:integer)
    required(:weight).filled(:float)
    optional(:doctor_ids).array(:string)
  end

  rule(:first_name) do
    ValidationMacros.validate_first_name(value, key)
  end

  rule(:last_name) do
    ValidationMacros.validate_last_name(value, key)
  end

  rule(:middle_name) do
    ValidationMacros.validate_middle_name(value, key) if value.present?
  end

  rule(:birthday) do
    ValidationMacros.validate_birthday(value, key)
  end

  rule(:gender) do
    ValidationMacros.validate_gender(value, key)
  end

  rule(:height) do
    ValidationMacros.validate_height(value, key)
  end

  rule(:weight) do
    ValidationMacros.validate_weight(value, key)
  end

  rule(:doctor_ids) do
    next unless value.present?

    value.each_with_index do |doctor_id, index|
      unless doctor_id.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
        key([:doctor_ids, index]).failure('должен быть валидным UUID')
      end
    end
  end
end
