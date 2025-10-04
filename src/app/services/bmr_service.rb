class BmrService < BaseService
  def calculate_for_patient(patient_id, formula = nil)
    raise ArgumentError, "Patient ID cannot be blank" if patient_id.blank?

    patient = Patient.find(patient_id)

    normalized_formula = normalize_formula(formula)

    unless patient.age
      raise ArgumentError, "Patient age cannot be determined. Please check patient's birthday."
    end

    unless patient.height && patient.weight && patient.gender
      raise ArgumentError, "Patient missing required data: height, weight, or gender."
    end

    unless BmrStrategyFactory.available_formulas.include?(normalized_formula)
      available = BmrStrategyFactory.available_formulas.join(', ')
      raise ArgumentError, "Invalid formula '#{formula}'. Available formulas: #{available}"
    end

    strategy = BmrStrategyFactory.create(normalized_formula)
    result = strategy.calculate(
      patient.age, 
      patient.height, 
      patient.weight, 
      patient.gender
    ).round(2)

    calculation = patient.bmr_calculations.create!(
      formula: normalized_formula,
      result: result
    )

    calculation
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(Patient, patient_id)
  end



  private
  def normalize_formula(formula)
    return 'mifflin' if formula.blank?

    cleaned_formula = formula.to_s.strip.downcase
    return 'mifflin' if cleaned_formula.empty?

    cleaned_formula
  end
end
