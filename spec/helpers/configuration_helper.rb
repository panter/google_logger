# frozen_string_literal: true

module ConfigurationHelper
  def configure_google_logger
    GoogleLogger.configuration = nil

    GoogleLogger.configure do |config|
      config.project_id = ENV.fetch('GOOGLE_LOGGER_TEST_PROJECT_ID', nil)
      config.credentials = {
        type: ENV.fetch('GOOGLE_LOGGER_TEST_TYPE', nil),
        project_id: ENV.fetch('GOOGLE_LOGGER_TEST_PROJECT_ID', nil),
        private_key_id: ENV.fetch('GOOGLE_LOGGER_TEST_PRIVATE_KEY_ID', nil),
        private_key: ENV.fetch('GOOGLE_LOGGER_TEST_PRIVATE_KEY', nil),
        client_email: ENV.fetch('GOOGLE_LOGGER_TEST_CLIENT_EMAIL', nil),
        client_id: ENV.fetch('GOOGLE_LOGGER_TEST_CLIENT_ID', nil),
        auth_uri: ENV.fetch('GOOGLE_LOGGER_TEST_AUTH_URI', nil),
        token_uri: ENV.fetch('GOOGLE_LOGGER_TEST_TOKEN_URI', nil),
        auth_provider_x509_cert_url: ENV.fetch('GOOGLE_LOGGER_TEST_AUTH_PROVIDER_CERT_URL', nil),
        client_x509_cert_url: ENV.fetch('GOOGLE_LOGGER_TEST_CLIENT_CERT_URL', nil)
      }
      config.async = false
    end
  end

  def configure_google_logger_for_local_logging
    GoogleLogger.configuration = nil

    GoogleLogger.configure do |config|
      config.log_locally = true
      config.local_logger = Logger.new($stdout)
    end
  end
end
