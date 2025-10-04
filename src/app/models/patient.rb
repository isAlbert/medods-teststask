class Patient < ActiveRecord::Base
  paginates_per 20
  max_paginates_per 100

  has_and_belongs_to_many :doctors,
                          join_table: 'patient_doctors'

  has_many :bmr_calculations, dependent: :destroy

  validates :first_name, :last_name, :birthday, :gender, :height, :weight, presence: true
  validates :first_name, length: { minimum: 2, maximum: 50, message: 'должно содержать от 2 до 50 символов' }
  validates :last_name, length: { minimum: 2, maximum: 50, message: 'должно содержать от 2 до 50 символов' }
  validates :middle_name, length: { maximum: 50, message: 'не должно превышать 50 символов' }, allow_blank: true
  validates :gender, inclusion: { in: %w[male female], message: 'должен быть male или female' }
  validates :height, numericality: {
    greater_than: 30,
    less_than: 300,
    only_integer: true,
    message: 'должен быть от 30 до 300 см'
  }
  validates :weight, numericality: {
    greater_than: 10,
    less_than: 500,
    message: 'должен быть от 10 до 500 кг'
  }

  validate :birthday_not_in_future
  validate :reasonable_age

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
  scope :by_gender, ->(gender) {
    where(gender: gender) if gender.present? && %w[male female].include?(gender.to_s.downcase)
  }



  def age
    return nil if birthday.nil?
    return nil if birthday > Date.current

    ((Date.current - birthday) / 365.25).to_i
    rescue => e
      Rails.logger&.warn "Age calculation error: #{e.message}"
      nil

  end


  private

  def birthday_not_in_future
    return unless birthday.present?

    if birthday > Date.current
      errors.add(:birthday, "не может быть в будущем")
    end
  end

  def reasonable_age
    return unless birthday.present?

    calculated_age = age
    if calculated_age && calculated_age > 150
      errors.add(:birthday, "указывает на нереальный возраст (#{calculated_age} лет)")
    elsif calculated_age && calculated_age < 0
      errors.add(:birthday, "указывает на отрицательный возраст")
    end
  end
end
