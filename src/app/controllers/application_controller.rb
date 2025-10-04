class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActionController::ParameterMissing, with: :handle_bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error
  rescue_from ArgumentError, with: :handle_argument_error

  private

  def extract_pagination_params(params)
    {
      page: params[:page],
      per_page: params[:per_page]
    }
  end

  def extract_filter_params(params)
    {
      search: params[:search],
      gender: params[:gender]
    }
  end

  def validate_uuid_param(id)
    unless id.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
      render_error("Invalid ID format")
    end
    true
  end

  def handle_not_found(exception)
    render_error("Record not found")
  end

  def handle_bad_request(exception)
    render_error(exception.message)
  end

  def handle_validation_error(exception)
    render_error(exception.message)
  end

  def handle_argument_error(exception)
    render_error(exception.message)
  end

  def render_resource(serializer_class, record, status: :ok)
    raw = serializer_class.new(record).serializable_hash
    attrs = raw[:data][:attributes].merge(id: raw[:data][:id])
    render json: { success: true, data: attrs }, status: status
  end

  def render_collection(serializer_class, records, meta: {})
    raw = serializer_class.new(records).serializable_hash
    data = raw[:data].map { |r| r[:attributes].merge(id: r[:id]) }
    render json: { success: true, data: data, meta: meta }
  end

  def render_error(message, details: [], status: :bad_request)
    render json: { success: false, error: message, details: details }, status: status
  end
end
