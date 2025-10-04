require 'httparty'

class BmiService < BaseService
  include HTTParty

  def calculate(height, weight)

    if height.blank? && weight.blank?
      raise ArgumentError, "Height and weight are required"
    elsif height.blank?
      raise ArgumentError, "Height is required"
    elsif weight.blank?
      raise ArgumentError, "Weight is required"
    end

    result = BmiContract.new.call(height: height, weight: weight)

    unless result.success?
      raise ArgumentError, format_contract_errors(result)
    end

    validated_params = result.to_h
    height_f = validated_params[:height].to_f
    weight_f = validated_params[:weight].to_f
    res = "https://bmicalculatorapi.vercel.app/api/bmi/#{weight_f}/#{height_f}"
    Rails.logger.info("Call #{res}") if defined?(Rails.logger)
    begin
      response = HTTParty.get(res, timeout: 30)

      Rails.logger.info(" from call #{res}\n\t\t-> #{response}") if defined?(Rails.logger)

      if response.success?
        data = response.parsed_response || {}
        {
          bmi: (data['bmi'] || 0).to_f.round(2),
          category: data['Category'] || 'Unknown'
        }
      else
        raise
      end
    rescue
      raise
    end
  end

  private

end
