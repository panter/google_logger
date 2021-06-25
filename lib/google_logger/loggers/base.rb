# frozen_string_literal: true

module GoogleLogger
  module Loggers
    class Base
      protected

      def configuration
        GoogleLogger.configuration
      end
    end
  end
end
