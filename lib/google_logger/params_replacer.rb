# frozen_string_literal: true

module GoogleLogger
  class ParamsReplacer
    def deep_replace_secret_params(arg)
      case arg
      when Hash
        deep_replace_params_in_hash(arg)
      when Array
        deep_replace_params_in_array(arg)
      end
    end

    def deep_replace_params_in_hash(hash)
      hash.each do |key, value|
        if GoogleLogger.configuration.secret_params.include?(key.to_sym)
          hash[key] = GoogleLogger.configuration.secret_param_value
        else
          deep_replace_secret_params(value)
        end
      end
    end

    def deep_replace_params_in_array(array)
      array.each { |item| deep_replace_secret_params(item) }
    end

    class << self
      delegate :deep_replace_secret_params, to: :new
    end
  end
end
