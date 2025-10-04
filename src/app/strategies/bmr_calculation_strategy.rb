module BmrCalculationStrategy
  def calculate(age, height, weight, gender)
    raise NotImplementedError, "Subclasses must implement #calculate"
  end

  private

  def validate_parameters(age, height, weight, gender)
    errors = []

    errors << "Age cannot be nil" if age.nil?
    errors << "Height cannot be nil" if height.nil?
    errors << "Weight cannot be nil" if weight.nil?
    errors << "Gender cannot be nil" if gender.nil?

    errors << "Age must be positive" if age && age <= 0
    errors << "Height must be positive" if height && height <= 0
    errors << "Weight must be positive" if weight && weight <= 0
    errors << "Gender must be male or female" if gender && !%w[male female].include?(gender.to_s.downcase)

    raise ArgumentError, errors.join(', ') if errors.any?
  end
end

class MifflinStJeorStrategy
  include BmrCalculationStrategy

  def calculate(age, height, weight, gender)
    validate_parameters(age, height, weight, gender)

    base = 10 * weight.to_f + 6.25 * height.to_f - 5 * age.to_f
    gender.to_s.downcase == 'male' ? base + 5 : base - 161
  rescue => e
    Rails.logger&.error "Mifflin-St Jeor calculation error: #{e.message}"
    raise
  end
end

class HarrisBenedictStrategy
  include BmrCalculationStrategy

  def calculate(age, height, weight, gender)
    validate_parameters(age, height, weight, gender)

    age_f = age.to_f
    height_f = height.to_f
    weight_f = weight.to_f

    if gender.to_s.downcase == 'male'
      88.362 + 13.397 * weight_f + 4.799 * height_f - 5.677 * age_f
    else
      447.593 + 9.247 * weight_f + 3.098 * height_f - 4.330 * age_f
    end
  rescue => e
    Rails.logger&.error "Harris-Benedict calculation error: #{e.message}"
    raise
  end
end

class BmrStrategyFactory
  STRATEGIES = {
    'mifflin' => MifflinStJeorStrategy.new,
    'harris'  => HarrisBenedictStrategy.new
  }.freeze

  def self.create(formula)
    raise ArgumentError, "Formula cannot be blank" if formula.blank?

    normalized_formula = formula.to_s.strip.downcase
    strategy = STRATEGIES[normalized_formula]

    unless strategy
      available = available_formulas.join(', ')
      raise ArgumentError, "Unknown formula: #{formula}. Available: #{available}"
    end

    strategy
  end

  def self.available_formulas
    STRATEGIES.keys
  end

end
