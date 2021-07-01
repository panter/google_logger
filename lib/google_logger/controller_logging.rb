# frozen_string_literal: true

require 'active_support'

module GoogleLogger
  module ControllerLogging
    extend ActiveSupport::Concern

    included do
      protected

      # Logs the request and any uncaught exceptions, acts as an `around_action` filter.
      # Exceptions are propagated so that they can be caught in the application.
      def log_request_to_google
        GoogleLogger.log_request(request, google_log_params)
        yield
      rescue StandardError => e
        GoogleLogger.log_exception(e)
        raise
      end

      # Returns params which should be logged, secret params have their value hidden before being logged
      #
      # @return [Hash] params hash with secret values hidden
      def google_log_params
        params_to_log = params.to_unsafe_h
        GoogleLogger.deep_replace_secret_params(params_to_log)
        params_to_log
      end
    end
  end
end
