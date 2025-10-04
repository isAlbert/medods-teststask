class BmrContract < Dry::Validation::Contract
  params do
    required(:patient_id).filled(:string)
    optional(:formula).maybe(:string)
  end

  rule(:patient_id) do
    if value.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i)
      begin
        unless Patient.exists?(id: value)
          key.failure('пациент с таким ID не найден')
        end
      rescue => e
        Rails.logger&.error "Patient validation error: #{e.message}"
        key.failure('ошибка при проверке пациента')
      end
    else
      key.failure('должен быть валидным UUID пациента')
    end
  end

  rule(:formula) do
    next if value.blank?

    normalized_formula = value.to_s.strip.downcase
    unless %w[mifflin harris].include?(normalized_formula)
      key.failure('должна быть mifflin или harris')
    end
  end
end
