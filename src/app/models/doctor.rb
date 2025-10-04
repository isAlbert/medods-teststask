class Doctor < ActiveRecord::Base
  paginates_per 20
  max_paginates_per 100

  validates :first_name, :last_name, presence: true
  validates :first_name, length: { minimum: 2, maximum: 50, message: 'должно содержать от 2 до 50 символов' }
  validates :last_name, length: { minimum: 2, maximum: 50, message: 'должно содержать от 2 до 50 символов' }
  validates :middle_name, length: { maximum: 50, message: 'не должно превышать 50 символов' }, allow_blank: true


  has_and_belongs_to_many :patients,
                          join_table: 'patient_doctors'
  scope :search, ->(query) {
    if query.present?
      search_term = "%#{query.strip}%"
      where(
        "CONCAT(last_name, ' ', first_name, ' ', COALESCE(middle_name, '')) ILIKE ? OR
         CONCAT(first_name, ' ', last_name, ' ', COALESCE(middle_name, '')) ILIKE ? OR
         last_name ILIKE ? OR
         first_name ILIKE ?",
        search_term, search_term, search_term, search_term
      )
    end
  }

end
