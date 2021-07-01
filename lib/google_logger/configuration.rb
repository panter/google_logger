# frozen_string_literal: true

module GoogleLogger
  class Configuration
    attr_accessor(*%i[
                    async
                    resource_type
                    resource_labels
                    secret_params
                    secret_param_value
                    project_id
                    credentials
                    log_locally
                    local_logger
                  ])

    # Creates a new instance with default configuration values
    def initialize
      @async = true
      @resource_type = 'gae_app'
      @resource_labels = {}
      @secret_params = %i[password]
      @secret_param_value = '<SECRET_PARAM>'
      @log_locally = false
    end

    def validate!
      if @log_locally
        validate_local_logger
      else
        validate_credentials
      end
    end

    private

    def validate_local_logger
      raise_invalid!('"local_logger" must be provided if "log_locally" is set to "true"') if local_logger.nil?

      log_levels = GoogleLogger::Loggers::LocalLogger::SEVERITY_MAPPING.values.uniq + [:unknown]

      # make sure the logger responds to logger methods
      log_levels.each do |log_level|
        raise_invalid!("\"local_logger\" must respond to \"#{log_level}\"") unless local_logger.respond_to?(log_level)
      end
    end

    def validate_credentials
      return unless @project_id.nil? || @project_id == '' || @credentials.nil? || @credentials == ''

      raise_invalid!('"project_id" and "credentials" cannot be blank')
    end

    def raise_invalid!(message)
      raise InvalidConfigurationError, message
    end
  end
end
