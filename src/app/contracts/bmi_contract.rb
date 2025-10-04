class BmiContract < Dry::Validation::Contract
  params do
    required(:height).filled
    required(:weight).filled
  end

  rule(:height) do
    ValidationMacros.validate_height_f(value, key)
  end

  rule(:weight) do
    ValidationMacros.validate_weight(value, key)
  end

end
