# frozen_string_literal: true

require 'logger'

module GoogleLogger
  class JsonLogger < ::Logger
    SEVERITY_MAPPING = {
      UNKNOWN => :DEFAULT,
      FATAL => :CRITICAL,
      ERROR => :ERROR,
      WARN => :WARNING,
      INFO => :INFO,
      DEBUG => :DEBUG
    }.freeze

    def initialize(default_log_name: 'default')
      @default_log_name = default_log_name
      @tagged = nil
      self.level = DEBUG
    end

    private

    #
    # @see Logger#add
    #
    def add(severity, message = nil, progname = nil)
      return true if message.blank? && progname.blank?

      severity ||= UNKNOWN
      return true if severity < level

      create_formatted_log(severity, message, progname)
    end

    def create_formatted_log(severity, message = nil, progname = nil)
      log_name = tagged? ? formatter.current_tags.join('.') : @default_log_name
      GoogleLogger.create_entry(
        message || progname,
        log_name: log_name,
        severity: SEVERITY_MAPPING.fetch(severity)
      )
    end

    def tagged?
      formatter.respond_to?(:current_tags) && formatter.current_tags.any?
    end
  end
end
