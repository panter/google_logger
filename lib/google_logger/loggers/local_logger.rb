# frozen_string_literal: true

require 'base'

module GoogleLogger
  module Loggers
    class LocalLogger < Base
      SEVERITY_MAPPING = {
        DEFAULT: :info,
        DEBUG: :debug,
        INFO: :info,
        NOTICE: :info,
        WARNING: :warn,
        ERROR: :error,
        CRITICAL: :fatal,
        ALERT: :fatal,
        EMERGENCY: :fatal
      }.freeze

      # Builds a new entry
      #
      # @param [String, Hash] payload content of the log
      # @param [Hash] entry_args arguments which would normally be passed to google entry
      #
      # @return [Hash] entry with payload and default resource configuration
      def build_entry(payload, entry_args = {})
        entry_args[:payload] = payload
        entry_args
      end

      # Writes an entry to google cloud
      #
      # @param [Hash] entry entry to be written to google cloud
      #
      # return [Boolean] `true` if the entry was successfully written
      def write_entry(entry)
        log_level = SEVERITY_MAPPING[entry[:severity]] || :unknown
        configuration.local_logger.public_send(log_level, entry.inspect)

        true
      end
    end
  end
end
