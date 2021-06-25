# frozen_string_literal: true

require 'base'

module GoogleLogger
  module Loggers
    class CloudLogger < Base
      # Creates a new logger with project_id and credentials specified in configuration
      def initialize
        @project = Google::Cloud::Logging.new(
          project_id: configuration.project_id,
          credentials: configuration.credentials
        )
      end

      # Builds a new entry
      #
      # @param [String, Hash] payload content of the log
      # @param [String] log_name log_name which can be used to filter logs
      # @param [Symbol] severity severity of the log
      #
      # @return [Google::Cloud::Logging::Entry] entry with payload and default resource configuration
      def build_entry(payload, log_name: 'default_log', severity: :DEFAULT)
        entry = @project.entry(payload: payload, log_name: log_name, severity: severity, timestamp: Time.zone.now)
        entry.resource.type = configuration.resource_type
        entry.resource.labels = configuration.resource_labels
        entry
      end

      # Writes an entry to google cloud
      #
      # @param [Google::Cloud::Logging::Entry] entry entry to be written to google cloud
      # defaults to configuration value
      #
      # return [Boolean] `true` if the entry was successfully written
      def write_entry(entry)
        log_writer = configuration.async ? @project : @project.async_writer
        log_writer.write_entries(entry)
      end
    end
  end
end
