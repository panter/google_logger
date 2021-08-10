# frozen_string_literal: true

module ConfigurationHelper
  def configure_google_logger
    GoogleLogger.configuration = nil

    GoogleLogger.configure do |config|
      config.project_id = ENV['GOOGLE_LOGGER_TEST_PROJECT_ID']
      config.credentials = {
        type: ENV['GOOGLE_LOGGER_TEST_TYPE'],
        project_id: ENV['GOOGLE_LOGGER_TEST_PROJECT_ID'],
        private_key_id: ENV['GOOGLE_LOGGER_TEST_PRIVATE_KEY_ID'],
        private_key: ENV['GOOGLE_LOGGER_TEST_PRIVATE_KEY'],
        client_email: ENV['GOOGLE_LOGGER_TEST_CLIENT_EMAIL'],
        client_id: ENV['GOOGLE_LOGGER_TEST_CLIENT_ID'],
        auth_uri: ENV['GOOGLE_LOGGER_TEST_AUTH_URI'],
        token_uri: ENV['GOOGLE_LOGGER_TEST_TOKEN_URI'],
        auth_provider_x509_cert_url: ENV['GOOGLE_LOGGER_TEST_AUTH_PROVIDER_CERT_URL'],
        client_x509_cert_url: ENV['GOOGLE_LOGGER_TEST_CLIENT_CERT_URL']
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
