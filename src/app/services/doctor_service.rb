class DoctorService < BaseService
  def list(filters = {})
    filters = {} if filters.nil?

    doctors = Doctor.includes(:patients)

    search_term = sanitize_search(filters[:search])
    doctors = doctors.search(search_term) if search_term.present?

    paginated_doctors = paginate_safely(
      doctors, 
      page: filters[:page], 
      per_page: filters[:per_page]
    )

    {
      doctors: paginated_doctors,
      pagination: build_pagination_meta(paginated_doctors)
    }
  end

  def show(id)
    raise ArgumentError, "ID cannot be blank" if id.blank?

    Doctor.find(id)
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(Doctor, id)
  end

  def create(params)
    create_with_contract(Doctor, DoctorContract, params)
  end

  def update(id, params)
    raise ArgumentError, "ID cannot be blank" if id.blank?

    doctor = Doctor.find(id)
    update_with_contract(doctor, DoctorContract, params)
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(Doctor, id)
  end

  def destroy(id)
    raise ArgumentError, "ID cannot be blank" if id.blank?

    doctor = Doctor.find(id)
    doctor.destroy!
    doctor
  rescue ActiveRecord::RecordNotFound
    handle_record_not_found(Doctor, id)
  end
end
