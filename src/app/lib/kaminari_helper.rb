module KaminariHelper
  module_function

  def paginate_safely(collection, page: nil, per_page: nil)
    return collection if collection.nil?

    normalized_page = normalize_page(page)
    normalized_per_page = normalize_per_page(per_page)

    collection.page(normalized_page).per(normalized_per_page)
  rescue => e
    Rails.logger&.error "Pagination error: #{e.message}"
    collection
  end

  def build_pagination_meta(kaminari_collection)
    return {} if kaminari_collection.nil?

    {
      current_page: kaminari_collection.current_page || 1,
      per_page: kaminari_collection.limit_value || 20,
      total_count: kaminari_collection.total_count || 0,
      total_pages: kaminari_collection.total_pages || 1,
      has_next_page: kaminari_collection.next_page.present?,
      has_previous_page: kaminari_collection.prev_page.present?,
      next_page: kaminari_collection.next_page,
      previous_page: kaminari_collection.prev_page,
      is_first_page: kaminari_collection.first_page? || false,
      is_last_page: kaminari_collection.last_page? || false,
      offset: kaminari_collection.offset_value || 0
    }
  rescue => e
    Rails.logger&.error "Pagination meta building error: #{e.message}"
    default_pagination_meta
  end

  def extract_pagination_meta(paginated_collection)
    return {} if paginated_collection.nil?

    {
      current_page: paginated_collection.current_page,
      per_page: paginated_collection.limit_value,
      total_count: paginated_collection.total_count,
      total_pages: paginated_collection.total_pages,
      has_next_page: paginated_collection.next_page.present?,
      has_previous_page: paginated_collection.prev_page.present?,
      next_page: paginated_collection.next_page,
      previous_page: paginated_collection.prev_page
    }
  rescue => e
    Rails.logger&.error "Pagination meta extraction error: #{e.message}"
    {}
  end

  def normalize_page(page)
    return 1 if page.blank?

    page_int = page.to_i
    page_int > 0 ? page_int : 1
  rescue
    1
  end

  def normalize_per_page(per_page)
    return 20 if per_page.blank?

    per_page_int = per_page.to_i
    return 20 if per_page_int <= 0

    [per_page_int, 100].min
  rescue
    20
  end

  def default_pagination_meta
    {
      current_page: 1,
      per_page: 20,
      total_count: 0,
      total_pages: 1,
      has_next_page: false,
      has_previous_page: false,
      next_page: nil,
      previous_page: nil,
      is_first_page: true,
      is_last_page: true,
      offset: 0
    }
  end
end
