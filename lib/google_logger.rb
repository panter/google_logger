# frozen_string_literal: true

require 'stackdriver'
require 'google_logger/version'
require 'google_logger/configuration'
require 'google_logger/loggers/cloud_logger'
require 'google_logger/loggers/local_logger'
require 'google_logger/loggers/base'
require 'google_logger/controller_logging'
require 'google_logger/params_replacer'

# Main module which should serve as an interface to all functionalities
module GoogleLogger
  class Error < StandardError; end

  class InvalidConfigurationError < Error; end

  class << self
    attr_writer :configuration

    # Returns GoogleLogger configuration
    #
    # @return [GoogleLogger::Configuration] current GoogleLogger configuration
    def configuration
      @configuration ||= Configuration.new
    end

    # Yields the cofiguration class
    #
    # @yield [GoogleLogger::Configuration] current GoogleLogger configuration
    #
    # @return [GoogleLogger::Configuration] GoogleLogger configuration with assigned values
    def configure
      yield(configuration) if block_given?

      configuration.validate!

      configuration
    end

    # Creates a new entry
    #
    # @param [String, Hash] payload content of the log
    # @param [String] log_name log_name which can be used to filter logs
    # @param [Symbol] severity severity of the log
    #
    # return [Boolean] `true` if the entry was successfully written
    def create_entry(payload, log_name: 'default_log', severity: :DEFAULT)
      logger_instance = logger
      entry = logger_instance.build_entry(payload, log_name: log_name, severity: severity)
      logger_instance.write_entry(entry)
    end

    # Creates a new entry for an exception which includes exception message, class and backtrace
    #
    # @param [StandardError] exception exception to be logged
    #
    # return [Boolean] `true` if the entry was successfully written
    def log_exception(exception)
      payload = {
        message: exception.message,
        exception: exception.class.name,
        bactrace: exception.backtrace&.first(5)
      }

      create_entry(payload, log_name: 'error', severity: :ERROR)
    rescue StandardError => e
      log_google_logger_error(e)
    end

    # Creates a new entry for a controller request, the entry includes params,
    # request URL, client ip address and http method
    #
    # @param [ActionDispatch::Request] request request to be logged
    # @param [ActionController::StrongParameters] params parameters to be logged
    #
    # return [Boolean] `true` if the entry was successfully written
    def log_request(request, params)
      payload = {
        params: params,
        original_url: request.original_url,
        ip: request.ip,
        method: request.method
      }

      create_entry(payload, log_name: 'request', severity: :INFO)
    rescue StandardError => e
      log_google_logger_error(e)
    end

    # Returns the currently used logger
    #
    # @return [Object] GoogleLogger::Logger by default, local logger if `loc_locally` is set to true
    def logger
      if configuration.log_locally
        Loggers::LocalLogger.new
      else
        Loggers::CloudLogger.new
      end
    end

    # Log gem errors locally if local_logger is present
    #
    # @param [StandardError] exception the error that will be logged
    def log_google_logger_error(exception)
      local_logger = GoogleLogger.configuration.local_logger
      local_logger.error "GOOGLE_LOGGER ERROR: #{exception.inspect}" if local_logger.present?
    end

    def deep_replace_secret_params(params)
      ParamsReplacer.deep_replace_secret_params(params)
    end
  end
end
