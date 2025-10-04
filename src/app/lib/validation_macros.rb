module ValidationMacros
  module_function

  # Валидация имени (first_name)
  def validate_first_name(value, key)
    validate_name_field(value, key, 'Имя')
  end

  # Валидация фамилии (last_name)
  def validate_last_name(value, key)
    validate_name_field(value, key, 'Фамилия')
  end

  # Валидация отчества (middle_name) - опционально
  def validate_middle_name(value, key)
    return if value.blank?
    validate_name_field(value, key, 'Отчество')
  end

  # Общая валидация полей имени
  def validate_name_field(value, key, field_name)
    if value.blank?
      key.failure("#{field_name} не может быть пустым")
      return
    end

    cleaned_value = value.to_s.strip

    if cleaned_value.length < 2
      key.failure("#{field_name} должно содержать минимум 2 символа")
    elsif cleaned_value.length > 50
      key.failure("#{field_name} не должно превышать 50 символов")
    elsif !cleaned_value.match?(/\A[\p{L}\s\-']+\z/)
      key.failure("#{field_name} может содержать только буквы, пробелы, дефисы и апострофы")
    elsif cleaned_value.match?(/\A[\s\-']+\z/)
      key.failure("#{field_name} не может состоять только из пробелов и знаков препинания")
    end
  end

  def validate_birthday(value, key)
    if value.blank?
      key.failure('Дата рождения не может быть пустой')
      return
    end

    begin
      date_value = value.is_a?(String) ? Date.parse(value) : value

      if date_value > Date.current
        key.failure('Дата рождения не может быть в будущем')
      end
    rescue ArgumentError
      key.failure('Неправильный формат даты')
    end
  end

  def validate_gender(value, key)
    if value.blank?
      key.failure('Пол не может быть пустым')
      return
    end

    normalized = value.to_s.strip.downcase
    unless %w[male female].include?(normalized)
      key.failure('Пол должен быть male или female')
    end
  end

  def validate_height(value, key)
    if value.blank?
      key.failure('Рост не может быть пустым')
      return
    end

    normalized_height = normalize_numeric(value)

    if normalized_height <= 0
      key.failure('Рост должен быть положительным числом')
    elsif normalized_height < 30
      key.failure('Рост слишком мал, минимум 30см')
    elsif normalized_height > 300
      key.failure('Рост слишком велик, максимум 300см')
    end
  end

  def validate_height_f(value, key)
    if value.blank?
      key.failure('Рост не может быть пустым')
      return
    end

    normalized_height = normalize_numeric(value)

    if normalized_height <= 0
      key.failure('Рост должен быть положительным числом')
    elsif normalized_height < 0.30
      key.failure('Рост слишком мал, минимум 30см')
    elsif normalized_height > 300
      key.failure('Рост слишком велик, максимум 300см')
    end
  end

  def validate_weight(value, key)
    if value.blank?
      key.failure('Вес не может быть пустым')
      return
    end

    normalized_weight = normalize_numeric(value)

    if normalized_weight <= 0
      key.failure('Вес должен быть положительным числом')
    elsif normalized_weight < 10
      key.failure('Вес слишком мал, минимум 10кг')
    elsif normalized_weight > 500
      key.failure('Вес слишком велик, максимум 500кг')
    end
  end

  def normalize_numeric(value)
    return 0.0 if value.nil?

    case value
    when String
      cleaned = value.strip.gsub(/[^0-9.-]/, '')
      cleaned.to_f
    when Numeric
      value.to_f
    else
      0.0
    end
  rescue
    0.0
  end
end
