class PatientService < BaseService
  def list(filters = {})
    filters = {} if filters.nil?

    patients = Patient.includes(:doctors)

    search_term = sanitize_search(filters[:search])
    patients = patients.search(search_term) if search_term.present?

    gender = normalize_gender(filters[:gender])
    patients = patients.by_gender(gender) if gender.present?

    paginated_patients = paginate_safely(
      patients, 
      page: filters[:page], 
      per_page: filters[:per_page]
    )

    {
      patients: paginated_patients,
      pagination: build_pagination_meta(paginated_patients)
    }
  end

  def show(id)
    raise ArgumentError, "ID cannot be blank" if id.blank?

    Patient.find(id)
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(Patient, id)
  end

  def create(params)
    create_with_contract(Patient, PatientContract, params)
  end

  def update(id, params)
    raise ArgumentError, "ID cannot be blank" if id.blank?

    patient = Patient.find(id)
    update_with_contract(patient, PatientContract, params)
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(Patient, id)
  end

  def destroy(id)
    raise ArgumentError, "ID cannot be blank" if id.blank?

    patient = Patient.find(id)
    patient.destroy!
    patient
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(Patient, id)
  end

  def bmr_history(id, filters = {})
    raise ArgumentError, "ID cannot be blank" if id.blank?

    filters = {} if filters.nil?

    patient = Patient.find(id)
    calculations = patient.bmr_calculations.recent

    if pagination_applied?(filters)
      paginated_calculations = paginate_safely(
        calculations, 
        page: filters[:page], 
        per_page: filters[:per_page]
      )

      {
        calculations: paginated_calculations,
        pagination: build_pagination_meta(paginated_calculations),
        patient: patient
      }
    else
      {
        calculations: calculations,
        patient: patient
      }
    end
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(Patient, id)
  end
end
