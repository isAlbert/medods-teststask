class BaseService
  include KaminariHelper

  private

  def build_kaminari_meta(kaminari_collection)
    build_pagination_meta(kaminari_collection)
  end

  def format_contract_errors(result)
    return "Validation failed" if result.nil? || result.errors.nil?

    result.errors.to_h.map { |field, messages| 
      "#{field}: #{Array(messages).join(', ')}" 
    }.join('; ')
  end


  def handle_record_not_found(model_class, id)
    model_name = model_class&.name || "Record"
    id_string = id.to_s.presence || "unknown"

    raise ActiveRecord::RecordNotFound, "#{model_name} with id '#{id_string}' not found"
  end


  def create_with_contract(model_class, contract_class, params)
    raise ArgumentError, "Model class cannot be nil" if model_class.nil?
    raise ArgumentError, "Contract class cannot be nil" if contract_class.nil?
    raise ArgumentError, "Params cannot be nil" if params.nil?

    contract = contract_class.new
    result = contract.call(params)

    if result.success?
      record = model_class.new(result.to_h)

      if record.save
        record
      else
        raise ActiveRecord::RecordInvalid, record
      end
    else
      raise ArgumentError, format_contract_errors(result)
    end
  end

  # Improved update with contract - null safety
  def update_with_contract(record, contract_class, params)
    raise ArgumentError, "Record cannot be nil" if record.nil?
    raise ArgumentError, "Contract class cannot be nil" if contract_class.nil?
    raise ArgumentError, "Params cannot be nil" if params.nil?

    contract = contract_class.new
    result = contract.call(params)

    if result.success?
      if record.update(result.to_h)
        record
      else
        raise ActiveRecord::RecordInvalid, record
      end
    else
      raise ArgumentError, format_contract_errors(result)
    end
  end


  def sanitize_search(search_term)
    return nil if search_term.blank?

    cleaned = search_term.to_s.strip
    cleaned.length >= 2 ? cleaned : nil
  end

  def normalize_gender(gender)
    return nil if gender.blank?

    cleaned = gender.to_s.strip.downcase
    %w[male female].include?(cleaned) ? cleaned : nil
  end
end
